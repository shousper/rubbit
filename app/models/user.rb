class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts

  validates :username, presence: true,
                       length: { maximum: 30 },
                       uniqueness: { case_sensitive: false }

  # Default karma for new users.
  before_create { self.karma = 1 }

  def to_param
    username
  end

end
