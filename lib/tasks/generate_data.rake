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
  count = 50
  print "  Creating #{count} posts."
  users = User.all
  count.times do
    user = users.sample(1).first
    user.posts.create!(body: Faker::Lorem.paragraph(rand(1..5)))
    print '.'
  end
  puts '.'
end

def make_replies
  count = 500
  print "  Creating #{count} replies to posts."
  users = User.all
  count.times do
    posts = Post.all
    post = posts.sample(1).first.children.create(body: Faker::Lorem.paragraph(rand(1..5)))
    post.user = users.sample(1).first
    post.save!
    print '.'
  end
  puts '.'
end

def randomise_votes
  count = 200
  print "  Randomising votes on #{count} posts."
  users = User.all
  Post.all.sample(count).each do |post|
    rand(10..100).times { post.vote_up!(users.sample(1).first) }
    rand(0..25).times { post.vote_down!(users.sample(1).first) }
    print '.'
  end
  puts '.'
end