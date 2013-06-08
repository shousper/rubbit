class Post < ActiveRecord::Base
  include ActsAsTree

  attr_accessible :body

  acts_as_tree order: "votes DESC, updated_at DESC"

  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true

  after_create :vote_up!

  def vote_down!(voter)
    self.decrement! :votes
    voter.decrement! :karma # Costs karma to down vote someone else.
    user.decrement! :karma # Costs poster karma to be down voted as well.
  end

  def vote_up!(voter)
    self.increment! :votes
    if user == voter
      voter.decrement! :karma # Costs karma to up vote yourself.
    else
      user.increment! :karma # Boosts posters karma.
    end
  end

  # Returns total number of comments below this post.
  def count_children
    count = children.count
    if count
      children.each { |child| count += child.count_children }
    end
    count
  end

end
