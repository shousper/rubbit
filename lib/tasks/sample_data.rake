namespace :rubbit do
  desc "Add admin user."
  task 'create-admin' => :environment do
    admin = User.create!(username: 'shousper',
                         email: 'dormant.aura@gmail.com',
                         password: 'password',
                         password_confirmation: 'password')
  end
end