# Seeds for Eventicus
puts "Seeding database..."

# Disable geocoding during seed
Location.skip_callback(:validation, :after, :geocode)

# Categories
categories = [
  { name: "Konzert", position: 1 },
  { name: "Party", position: 2 },
  { name: "Konferenz", position: 3 },
  { name: "Workshop", position: 4 },
  { name: "Sport", position: 5 },
  { name: "Kunst & Kultur", position: 6 },
  { name: "Networking", position: 7 },
  { name: "Sonstiges", position: 99 }
]

categories.each do |cat|
  Category.find_or_create_by!(name: cat[:name]) do |c|
    c.position = cat[:position]
  end
end
puts "Created #{Category.count} categories"

# Cities
cities = [
  { name: "Hamburg", state: "Hamburg", country: "Deutschland" },
  { name: "Berlin", state: "Berlin", country: "Deutschland" },
  { name: "München", state: "Bayern", country: "Deutschland" },
  { name: "Köln", state: "Nordrhein-Westfalen", country: "Deutschland" },
  { name: "Frankfurt", state: "Hessen", country: "Deutschland" }
]

cities.each do |city|
  City.find_or_create_by!(name: city[:name], country: city[:country]) do |c|
    c.state = city[:state]
  end
end
puts "Created #{City.count} cities"

# Demo user
demo_user = User.find_or_create_by!(email: "demo@eventicus.de") do |u|
  u.username = "demo"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.first_name = "Demo"
  u.last_name = "User"
end
puts "Created demo user: demo@eventicus.de / password123"

# Sample locations
hamburg = City.find_by(name: "Hamburg")
if hamburg
  locations = [
    { name: "Elbphilharmonie", street: "Platz der Deutschen Einheit 1", zip: "20457" },
    { name: "Fabrik", street: "Barnerstraße 36", zip: "22765" },
    { name: "Mojo Club", street: "Reeperbahn 1", zip: "20359" }
  ]
  
  locations.each do |loc|
    Location.find_or_create_by!(name: loc[:name], city: hamburg) do |l|
      l.street = loc[:street]
      l.zip = loc[:zip]
    end
  end
  puts "Created #{Location.count} locations"

  # Sample events
  concert = Category.find_by(name: "Konzert")
  party = Category.find_by(name: "Party")
  elphi = Location.find_by(name: "Elbphilharmonie")
  mojo = Location.find_by(name: "Mojo Club")

  if elphi && concert
    Event.find_or_create_by!(title: "Klassik Abend") do |e|
      e.description = "Ein wunderschöner Abend mit klassischer Musik in der Elbphilharmonie."
      e.starts_at = 2.weeks.from_now.change(hour: 19, min: 30)
      e.ends_at = 2.weeks.from_now.change(hour: 22, min: 0)
      e.user = demo_user
      e.location = elphi
      e.category = concert
    end
  end

  if mojo && party
    Event.find_or_create_by!(title: "Indie Night") do |e|
      e.description = "Die beste Indie-Musik der Stadt! DJs aus Hamburg und Berlin."
      e.starts_at = 1.week.from_now.change(hour: 23, min: 0)
      e.ends_at = 1.week.from_now.change(hour: 5, min: 0) + 1.day
      e.user = demo_user
      e.location = mojo
      e.category = party
    end
  end
  
  puts "Created #{Event.count} events"
end

puts "Done!"
