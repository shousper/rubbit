namespace :rubbit do
  desc "Add admin user."
  task 'create-admin' => :environment do
    puts 'Creating administration user.'
    admin = User.create!(username: 'shousper',
                         email: 'shousper@rubbit.com',
                         password: 'password',
                         password_confirmation: 'password')
  end
end