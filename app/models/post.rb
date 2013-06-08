class Post < ActiveRecord::Base
  include ActsAsTree

  attr_accessible :body, :name, :parent_id

  acts_as_tree order: "votes DESC, updated_at DESC"

  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
  validates :path, length: { maximum: 255 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, allow_nil: true }

  before_create { self.votes = 1 }
  after_create  { self.user.increment! :karma }

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

  def name=(value)
    return unless value
    path = value.gsub(/[^A-Za-z0-9\-\_]/, '-')
    unless path.empty?
      if self.parent_id
        parent = Post.find(self.parent_id)
        path = "#{parent.path}:#{@post.path}" unless parent.path.nil? || parent.path.empty?
      end
      self.path = path
    end
  end

  def name
  end

  # Returns total number of comments below this post.
  def count_children
    count = children.count
    if count
      children.each { |child| count += child.count_children }
    end
    count
  end

  def to_param
    if path.nil? || path.empty?
      super
    else
      path
    end
  end

  def self.root_feed
    Post.where('parent_id IS NULL', '')
        .order('votes DESC, updated_at DESC')
  end

  def self.root_named_feed
    Post.where('path IS NOT NULL AND path != ?', '')
        .order('votes DESC, updated_at DESC')
  end

  def self.try_find(id)
    @post = Post.find(id)
  rescue
    @post = Post.find_by_path(id)
  end

end
