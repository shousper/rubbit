namespace :rubbit do
  desc "Generates sample data for testing."
  task 'generate-data' => :environment do
    puts 'Generating test data..'
    make_users
    make_posts
    make_replies
    randomise_votes
    puts 'Done!'
  end
end

def make_users
  count = 99
  print "  Creating #{count} users."
  count.times do |n|
    User.create!(username: "user-#{n+1}",
                 email: "example-#{n+1}@testing.com",
                 password: "password",
                 password_confirmation: "password")
    print '.'
  end
  puts '.'
end

def make_posts
  count = 200
  print "  Creating #{count} posts."
  count.times do
    user = User.first order: 'RANDOM()'
    path = nil
    path = Faker::Lorem.word.downcase if rand(1..10) >= 9
    user.posts.create(name: path, body: Faker::Lorem.paragraph(rand(1..5)))

    print '.'
  end
  puts '.'
end

def make_replies
  count = 1300
  print "  Creating #{count} replies to posts."
  users = User.all
  count.times do
    path = nil
    path = Faker::Lorem.word.downcase if rand(1..100) >= 99

    parent = Post.first order: 'RANDOM()'
    post = parent.children.create(name: path, body: Faker::Lorem.paragraph(rand(1..5)))
    post.user = users.sample(1).first
    post.path = nil if Post.exists?(path: post.path)
    post.save!

    print '.'
  end
  puts '.'
end

def randomise_votes
  count = 2000
  print "  Randomising votes on #{count} posts."
  Post.order('RANDOM()').limit(count).each do |post|
    Post.transaction do
      rand(10..100).times { post.vote_up!(User.first(order: 'RANDOM()')) }
      rand(0..25).times { post.vote_down!(User.first(order: 'RANDOM()')) }
    end
    print '.'
  end
  puts '.'
end