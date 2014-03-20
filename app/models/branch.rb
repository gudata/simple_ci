class Branch < ActiveRecord::Base
  belongs_to :repository
  has_many :commits, dependent: :delete_all
  has_many :scripts, dependent: :delete_all
  scope :active, ->() {where(build: true)}
  dragonfly_accessor :image
  validates :name, presence: true
  before_create :create_token

  def tip_commit
    Commit.includes(:committer).find_by(oid: self.tip_oid) || Commit.new
  end

  protected
  def generate_uniq_seed
    SecureRandom.urlsafe_base64(12, true)
  end

  def create_token
    self.token = generate_uniq_seed
  end

end
