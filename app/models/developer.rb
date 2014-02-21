class Developer < ActiveRecord::Base
  has_many :commits
  has_many :commits_as_author
  has_many :commits_as_commiter

  class << self

    def author_from commit
      Developer.find_or_create_by(email: commit.author[:email], name: commit.author[:name])
    end

    def commiter_from commit
      Developer.find_or_create_by(email: commit.committer[:email], name: commit.committer[:name])
    end

  end
end
