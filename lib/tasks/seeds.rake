namespace :db do
  namespace :seed do
    desc "Load base data (categories, cities, locations)"
    task base: :environment do
      require_relative "../../db/seeds/base_data"
      Seeds::BaseData.call
    end

    desc "Generate demo data with Faker (USERS=20 EVENTS=100)"
    task demo: :environment do
      require_relative "../../db/seeds/demo_data"
      Seeds::DemoData.call
    end

    desc "Reset database and seed with demo data"
    task reset: :environment do
      puts "🗑️  Resetting database..."
      
      # Clear all data
      [Comment, Attendance, Event, Location, Category, City, User].each do |model|
        model.delete_all
        puts "   Cleared #{model.name}"
      end

      # Re-seed
      Rake::Task["db:seed:base"].invoke
      Rake::Task["db:seed:demo"].invoke
      
      puts "\n✅ Database reset complete!"
    end

    desc "Generate large dataset for performance testing (1000 events)"
    task stress: :environment do
      require_relative "../../db/seeds/base_data"
      require_relative "../../db/seeds/demo_data"

      Seeds::BaseData.call
      Seeds::DemoData.call(users: 100, events: 1000)
    end
  end
end

desc "Seed database with base + demo data"
task seed_all: ["db:seed:base", "db:seed:demo"]
