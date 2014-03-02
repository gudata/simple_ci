class Repository < ActiveRecord::Base
  has_many :branches, dependent: :destroy
  has_many :builds, dependent: :delete_all
  has_many :scripts, through: :branches

  validates :name, presence: true
  validates :path, presence: true
  validate :repository_path_exists

  dragonfly_accessor :image

  before_destroy {
    clean_repository_data
  }

  def open
    @rugged_repository = Rugged::Repository.new(path)
    self
  end

  def repository_path_exists
    if path.blank? or !Dir.exists?(path)
       errors[:base] << "Invalid path #{self.path}"
    end
  end

  def refresh_branch branch_name
    git_branch = Rugged::Branch.lookup(@rugged_repository, branch_name)
    branch = Branch.find_or_create_by(name: branch_name)
    branch.repository = self
    branch.canonical_name = git_branch.canonical_name
    branch.tip_oid = Rugged::Branch.lookup(@rugged_repository, branch_name).tip.oid
    branch.save
  end

  def refresh_branches
    all_branches = Rugged::Branch.each_name(@rugged_repository, :local).sort
    all_branches.each do |branch_name|
      refresh_branch branch_name
    end
  end

  def checkout oid
    git = Git.new(self.path)
    git.execute "checkout -f #{oid}"
    git.execute "reset --hard"
    git.execute "clean -fdxq"
  end

  def work_on_ref oid
    open
    old_ref = @rugged_repository.head.target
    puts " work_on_ref was on: #{old_ref}"
    puts " checkout #{oid}"
    checkout oid
    yield
    checkout old_ref
    puts " checkout #{old_ref}"
  end

  def fetch_from_remotes
    git = Git.new(self.path)
    git.execute("fetch --all")
  end

  def goto_branch branch_name
    git = Git.new(self.path)
    git.execute("checkout -f #{branch_name}")
  end

  def status
    git = Git.new(self.path)
    git.execute("status")
  end

  def merge_remote_local branch_name
    git = Git.new(self.path)
    git.execute("merge origin/#{branch_name} #{branch_name}")
  end

  # update the local commits. It is assumed that import has been done first.
  def refresh_all_commits
    fetch_from_remotes
    open
    refresh_branches
    branches.active.find_each do |branch|
      goto_branch branch.name
      merge_remote_local branch.name
      refresh_commits(branch)
    end
  end

  def master_branch
    branches.select{|branch| branch.name == 'master'}.first
  end

  # Reads new commits, creating builds
  def refresh_commits branch
    refresh_branch branch.name
    return if branch.tip_oid.blank?

    create_builds_flag = branch.commits.count > 0

    walker = Rugged::Walker.new(@rugged_repository)
    walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_DATE | Rugged::SORT_REVERSE) # https://github.com/libgit2/rugged/blob/bd062e5cc99ff9ea1dc924d032843718493aaa2d/ext/rugged/rugged.c
    walker.push(branch.tip_oid)
    # walker.hide(hex_sha_uninteresting)

    Commit.creating_builds(create_builds_flag) do
      Commit.transaction do
        puts "Reads new commits from #{branch.name} making builds - #{create_builds_flag}"
        walker.each_with_index do |git_commit, index|

          if Commit.exists?(branch_id: branch.id, oid: git_commit.oid)
            next
          end

          Commit.create({
            branch_id: branch.id,
            oid: git_commit.oid,
            message: git_commit.message,
            author_id: Developer.author_from(git_commit).id,
            committer_id: Developer.commiter_from(git_commit).id,
            time: git_commit.time,
          })

          if Commit.create_builds_flag
            puts " - create commit for #{git_commit.oid}"
          else
            print '.'
          end

        end # each commit
      end # transaction
    end # no builds

    walker.reset
    puts " - end reading new commits"
  end

  def clean_repository_data
    puts " - cleaning all repository data !!!"
    self.branches.each do |branch|
      branch.commits.delete_all
      branch.scripts.delete_all
    end
    self.branches.delete_all
    self.builds.delete_all
  end

end
