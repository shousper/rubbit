class Post < ActiveRecord::Base
  include ActsAsTree

  attr_accessible :body

  acts_as_tree order: "votes DESC, created_at DESC"

  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true

  after_create :vote_up!

  def vote_down!(voter)
    self.decrement! :votes
    user.decrement! :karma
    voter.decrement! :karma
  end

  def vote_up!
    self.increment! :votes
    user.increment! :karma
  end

  def count_children
    count = children.count
    if count
      children.each { |child| count += child.count_children }
    end
    count
  end

end
