class Commit < ActiveRecord::Base
  belongs_to :author, class_name: 'Developer'#, foreign_key: 'author_id'
  belongs_to :committer, class_name: 'Developer'#, foreign_key: 'commiter_id'
  belongs_to :branch
  has_one :repository, through: :branch
  has_many :builds, dependent: :destroy

  after_create :assign_build
  max_paginates_per 100

  cattr_accessor :skip_create_builds_flag
  @@skip_create_builds_flag = false

  class << self
    def without_creating_builds
      @@skip_create_builds_flag = true
      yield
      @@skip_create_builds_flag = false
    end
  end

  def create_pending_build
    Build.create(commit_id: self.id, repository_id: self.repository.id)
  end

  protected
  def assign_build
    return if skip_create_builds_flag
    create_pending_build
  end
end
