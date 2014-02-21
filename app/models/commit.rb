class Commit < ActiveRecord::Base
  belongs_to :author, class_name: 'Developer'#, foreign_key: 'author_id'
  belongs_to :committer, class_name: 'Developer'#, foreign_key: 'commiter_id'
  belongs_to :branch

  max_paginates_per 100
end