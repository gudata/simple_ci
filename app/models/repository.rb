class Repository < ActiveRecord::Base
  has_many :branches, dependent: :destroy
  has_many :builds

  validates :name, presence: true
  validates :path, presence: true

  dragonfly_accessor :image

  def open
    @rugged_repository = Rugged::Repository.new(path)
    self
  end

  # def commit oid
  #   @rugged_repository.read oid
  # end

  def found?
    Dir.exists? self.path
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

  def fetch_from_remotes
    git = Git.new(self.path)
    git.execute("fetch --all")
  end

  def goto_branch branch_name
    git = Git.new(self.path)
    git.execute("checkout -f  --track  #{branch_name}")
    git.execute("pull")
  end

  # update the local commits. It is assumed that import has been done first.
  def refresh_all_commits
    fetch_from_remotes
    open
    refresh_branches
    branches.find_each do |branch|
      goto_branch branch.name
      refresh_commits(branch)
    end
  end

  # This is just update
  def refresh_commits branch
    refresh_branch branch.name
    return if branch.tip_oid.blank?

    walker = Rugged::Walker.new(@rugged_repository)
    walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_DATE) # https://github.com/libgit2/rugged/blob/bd062e5cc99ff9ea1dc924d032843718493aaa2d/ext/rugged/rugged.c
    walker.push(branch.tip_oid)
    # walker.hide(hex_sha_uninteresting)

    puts "#{branch.name}"
    puts "-"*100
    Commit.transaction do
      walker.each do |git_commit|

        puts "search for commit: #{ Commit.exists?(branch_id: branch.id, oid: git_commit.oid)}"
        break if Commit.exists?(branch_id: branch.id, oid: git_commit.oid)

        commit_params = {
          branch_id: branch.id,
          oid: git_commit.oid,
          message: git_commit.message,
          author_id: Developer.author_from(git_commit).id,
          committer_id: Developer.commiter_from(git_commit).id,
          time: git_commit.time,
        }
        puts commit_params.inspect
        puts "creating commit with params #{commit_params}"
        Commit.create(commit_params)
      end
    end
    walker.reset
  end


  # initial import
  def import_commits
    fetch_from_remotes
    open
    refresh_branches
    Commit.without_creating_builds do
      branches.find_each do |branch|
        import_commits_from_branch(branch)
      end
    end
  end


  # used by initial import
  def import_commits_from_branch branch
    return if branch.tip_oid.blank?
    refresh_branches

    walker = Rugged::Walker.new(@rugged_repository)
    walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_DATE) # https://github.com/libgit2/rugged/blob/bd062e5cc99ff9ea1dc924d032843718493aaa2d/ext/rugged/rugged.c
    walker.push(branch.tip_oid)
    # walker.hide(hex_sha_uninteresting)
    Commit.where(branch: branch).delete_all
    Commit.transaction do
      walker.each do |git_commit|
        Commit.create({
          branch_id: branch.id,
          oid: git_commit.oid,
          message: git_commit.message,
          author: Developer.author_from(git_commit),
          committer: Developer.commiter_from(git_commit),
          time: git_commit.time,
          })
      end
    end
    walker.reset
  end

end
