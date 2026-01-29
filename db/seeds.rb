# Main seeds file
# 
# Usage:
#   rails db:seed              - Runs base + demo data
#   rails db:seed:base         - Only base data (categories, cities, locations)
#   rails db:seed:demo         - Generate demo events with Faker
#   rails db:seed:reset        - Clear all and re-seed
#   rails db:seed:stress       - Generate 1000 events for performance testing
#
# Options (for demo seed):
#   USERS=50 EVENTS=200 rails db:seed:demo

require_relative "seeds/base_data"
require_relative "seeds/demo_data"

puts "🌱 Seeding Eventicus database..."
puts

Seeds::BaseData.call
Seeds::DemoData.call

puts
puts "🎉 Seeding complete!"
puts "   Demo login: demo@eventicus.de / password123"
