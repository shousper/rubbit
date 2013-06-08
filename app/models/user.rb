class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts

end
