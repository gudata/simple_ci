class Developer < ActiveRecord::Base
  has_many :commits
  has_many :commits_as_author
  has_many :commits_as_commiter
  has_secure_password

  class << self

    def author_from commit
      developer = Developer.find_by(email: commit.author[:email], name: commit.author[:name])

      if developer
        developer
      else
        create_developer(email: commit.author[:email], name: commit.author[:name])
      end
    end

    def commiter_from commit
      developer = Developer.find_by(email: commit.committer[:email], name: commit.committer[:name])

      if developer
        developer
      else
        create_developer(email: commit.committer[:email], name: commit.committer[:name]) unless developer
      end
    end

    def create_developer hash
      hash.merge!(password: hash[:email], password_confirmation: hash[:email], can_login: true)
      Developer.create(hash)
    end
  end
end
