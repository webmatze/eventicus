# Base data that should always exist
# Run with: rails db:seed:base

module Seeds
  class BaseData
    CATEGORIES = [
      { name: "Konzert", name_en: "Concert", position: 1, emoji: "🎵" },
      { name: "Party", name_en: "Party", position: 2, emoji: "🎉" },
      { name: "Konferenz", name_en: "Conference", position: 3, emoji: "🎤" },
      { name: "Workshop", name_en: "Workshop", position: 4, emoji: "🔧" },
      { name: "Sport", name_en: "Sports", position: 5, emoji: "⚽" },
      { name: "Kunst & Kultur", name_en: "Arts & Culture", position: 6, emoji: "🎨" },
      { name: "Networking", name_en: "Networking", position: 7, emoji: "🤝" },
      { name: "Comedy", name_en: "Comedy", position: 8, emoji: "😂" },
      { name: "Theater", name_en: "Theater", position: 9, emoji: "🎭" },
      { name: "Messe", name_en: "Trade Fair", position: 10, emoji: "🏢" },
      { name: "Festival", name_en: "Festival", position: 11, emoji: "🎪" },
      { name: "Sonstiges", name_en: "Other", position: 99, emoji: "📌" }
    ].freeze

    GERMAN_CITIES = [
      { name: "Hamburg", state: "Hamburg", country: "Deutschland" },
      { name: "Berlin", state: "Berlin", country: "Deutschland" },
      { name: "München", state: "Bayern", country: "Deutschland" },
      { name: "Köln", state: "Nordrhein-Westfalen", country: "Deutschland" },
      { name: "Frankfurt am Main", state: "Hessen", country: "Deutschland" },
      { name: "Stuttgart", state: "Baden-Württemberg", country: "Deutschland" },
      { name: "Düsseldorf", state: "Nordrhein-Westfalen", country: "Deutschland" },
      { name: "Leipzig", state: "Sachsen", country: "Deutschland" },
      { name: "Dortmund", state: "Nordrhein-Westfalen", country: "Deutschland" },
      { name: "Essen", state: "Nordrhein-Westfalen", country: "Deutschland" },
      { name: "Bremen", state: "Bremen", country: "Deutschland" },
      { name: "Dresden", state: "Sachsen", country: "Deutschland" },
      { name: "Hannover", state: "Niedersachsen", country: "Deutschland" },
      { name: "Nürnberg", state: "Bayern", country: "Deutschland" },
      { name: "Duisburg", state: "Nordrhein-Westfalen", country: "Deutschland" }
    ].freeze

    HAMBURG_LOCATIONS = [
      { name: "Elbphilharmonie", street: "Platz der Deutschen Einheit 1", zip: "20457", lat: 53.5413, lng: 9.9842 },
      { name: "Fabrik", street: "Barnerstraße 36", zip: "22765", lat: 53.5619, lng: 9.9354 },
      { name: "Mojo Club", street: "Reeperbahn 1", zip: "20359", lat: 53.5495, lng: 9.9631 },
      { name: "Knust", street: "Neuer Kamp 30", zip: "20357", lat: 53.5599, lng: 9.9666 },
      { name: "Gruenspan", street: "Große Freiheit 58", zip: "22767", lat: 53.5513, lng: 9.9589 },
      { name: "Uebel & Gefährlich", street: "Feldstraße 66", zip: "20359", lat: 53.5548, lng: 9.9665 },
      { name: "Kampnagel", street: "Jarrestraße 20", zip: "22303", lat: 53.5857, lng: 10.0182 },
      { name: "Thalia Theater", street: "Alstertor 1", zip: "20095", lat: 53.5536, lng: 9.9997 },
      { name: "Deutsches Schauspielhaus", street: "Kirchenallee 39", zip: "20099", lat: 53.5539, lng: 10.0073 },
      { name: "Laeiszhalle", street: "Johannes-Brahms-Platz 1", zip: "20355", lat: 53.5568, lng: 9.9863 },
      { name: "Barclays Arena", street: "Sylvesterallee 10", zip: "22525", lat: 53.5872, lng: 9.8987 },
      { name: "Markthalle Hamburg", street: "Klosterwall 11", zip: "20095", lat: 53.5489, lng: 10.0047 },
      { name: "Stage Club", street: "Stresemannstraße 163", zip: "22769", lat: 53.5611, lng: 9.9471 },
      { name: "Molotow", street: "Nobistor 14", zip: "22767", lat: 53.5498, lng: 9.9574 },
      { name: "Hafenklang", street: "Große Elbstraße 84", zip: "22767", lat: 53.5454, lng: 9.9421 }
    ].freeze

    BERLIN_LOCATIONS = [
      { name: "Berghain", street: "Am Wriezener Bahnhof", zip: "10243", lat: 52.5112, lng: 13.4429 },
      { name: "Tempodrom", street: "Möckernstraße 10", zip: "10963", lat: 52.4984, lng: 13.3831 },
      { name: "SO36", street: "Oranienstraße 190", zip: "10999", lat: 52.4996, lng: 13.4266 },
      { name: "Columbiahalle", street: "Columbiadamm 13-21", zip: "10965", lat: 52.4836, lng: 13.3892 },
      { name: "Volksbühne", street: "Linienstraße 227", zip: "10178", lat: 52.5269, lng: 13.4118 },
      { name: "Festsaal Kreuzberg", street: "Am Flutgraben 2", zip: "12435", lat: 52.4946, lng: 13.4447 },
      { name: "Lido", street: "Cuvrystraße 7", zip: "10997", lat: 52.4973, lng: 13.4428 },
      { name: "Heimathafen Neukölln", street: "Karl-Marx-Straße 141", zip: "12043", lat: 52.4776, lng: 13.4388 }
    ].freeze

    def self.call
      new.call
    end

    def call
      puts "Seeding base data..."

      create_categories
      create_cities
      create_locations

      puts "Base data seeding complete!"
    end

    private

    def create_categories
      CATEGORIES.each do |cat|
        Category.find_or_create_by!(name: cat[:name]) do |c|
          c.position = cat[:position]
        end
      end
      puts "  ✓ Created #{Category.count} categories"
    end

    def create_cities
      GERMAN_CITIES.each do |city|
        City.find_or_create_by!(name: city[:name], country: city[:country]) do |c|
          c.state = city[:state]
        end
      end
      puts "  ✓ Created #{City.count} cities"
    end

    def create_locations
      hamburg = City.find_by(name: "Hamburg")
      berlin = City.find_by(name: "Berlin")

      Location.skip_callback(:validation, :after, :geocode)

      if hamburg
        HAMBURG_LOCATIONS.each do |loc|
          Location.find_or_create_by!(name: loc[:name], city: hamburg) do |l|
            l.street = loc[:street]
            l.zip = loc[:zip]
            l.latitude = loc[:lat]
            l.longitude = loc[:lng]
          end
        end
      end

      if berlin
        BERLIN_LOCATIONS.each do |loc|
          Location.find_or_create_by!(name: loc[:name], city: berlin) do |l|
            l.street = loc[:street]
            l.zip = loc[:zip]
            l.latitude = loc[:lat]
            l.longitude = loc[:lng]
          end
        end
      end

      Location.set_callback(:validation, :after, :geocode)
      puts "  ✓ Created #{Location.count} locations"
    end
  end
end
