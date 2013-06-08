class Post < ActiveRecord::Base
  attr_accessible :body

  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true

  after_create :vote_up!

  def vote_down!
    self.decrement! :votes
    #user.decrement! :karma
    #current_user.decrement! :karma
  end

  def vote_up!
    self.increment! :votes
    #user.increment! :karma
  end

end
