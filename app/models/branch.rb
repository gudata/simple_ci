class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :commits, dependent: :destroy
  has_many :scripts, dependent: :destroy
  dragonfly_accessor :image
  validates :name, presence: true


  def tip_commit
    Commit.includes(:committer).find_by(oid: self.tip_oid) || Commit.new
  end
end
