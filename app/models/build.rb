class Build < ActiveRecord::Base
  belongs_to :commit
  has_one :branch, through: :commit
  has_one :repository, through: :branch

  scope :in_active_branch, ->() {joins(commit: [:branch]).where('branches.build=:flag', flag: true).readonly(false)}
  # scope :in_active_branch, ->() {joins(commit: [:branch]).where('branches.build=:flag', flag: true)}

  scope :for_repository, ->(repository_id) { includes(:branch, commit: [:committer]).joins(:repository).where("repositories.id = #{repository_id}") }

  max_paginates_per 100

  include Runnable
end

