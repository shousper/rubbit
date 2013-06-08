namespace :rubbit do
  desc "Generates sample data for testing."
  task 'generate-data' => :environment do
    puts 'Generating test data..'
    make_users
    make_posts
    randomise_votes
    puts 'Done!'
  end
end

def make_users
  count = rand(50..100)
  puts "  Creating #{count} users."
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
  count = rand(20..50)
  puts "  Creating #{count} posts."
  users = User.all
  count.times do |n|
    user = users.sample(1).first
    user.posts.create!(body: Faker::Lorem.paragraph(rand(1..5)))
    print '.'
  end
  puts '.'
end

def randomise_votes
  count = rand(200..300)
  puts "  Randomising votes on #{count} posts."
  Post.all.sample(count).each do |post|
    rand(10..100).times { post.vote_up! }
    rand(10..100).times { post.vote_down! }
    print '.'
  end
  puts '.'
end