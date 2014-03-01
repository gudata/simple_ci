class Commit < ActiveRecord::Base
  belongs_to :author, class_name: 'Developer'#, foreign_key: 'author_id'
  belongs_to :committer, class_name: 'Developer'#, foreign_key: 'commiter_id'
  belongs_to :branch
  has_one :repository, through: :branch
  has_many :builds, dependent: :delete_all

  scope :unbuilded_commits, ->() { joins("LEFT OUTER JOIN builds ON builds.commit_id = commits.id").order('created_at DESC') }

  after_create :assign_build
  max_paginates_per 100

  cattr_accessor :create_builds_flag
  @@create_builds_flag = false

  class << self
    def creating_builds flag
      @@create_builds_flag = flag
      yield
      @@create_builds_flag = true
    end
  end

  def create_pending_build
    Build.create(commit_id: self.id, oid: self.oid, repository_id: self.repository.id)
  end



  protected
  def assign_build
    return unless create_builds_flag
    create_pending_build
  end
end
