namespace :rubbit do
  desc "For development. Recreates and populates database."
  task reset: :environment do
    puts 'Resetting database.'
    Rake::Task["db:reset"].invoke
    Rake::Task["rubbit:create-admin"].invoke
    Rake::Task["rubbit:generate-data"].invoke
  end
end