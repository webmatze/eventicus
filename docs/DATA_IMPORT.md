# Daten-Import Strategien 📥

Dieses Dokument beschreibt verschiedene Möglichkeiten, externe Event-Daten in Eventicus zu importieren.

---

## 1. iCal Import (Priorität: Hoch)

### Beschreibung
iCal (.ics) ist das Standard-Format für Kalendereinträge. Viele Event-Plattformen bieten iCal-Exports an.

### Implementierung

```ruby
# app/services/ical_importer.rb
class IcalImporter
  def initialize(ical_content, default_city:, default_user:)
    @calendar = Icalendar::Calendar.parse(ical_content).first
    @default_city = default_city
    @default_user = default_user
  end

  def import
    @calendar.events.map do |ical_event|
      import_event(ical_event)
    end.compact
  end

  private

  def import_event(ical_event)
    Event.find_or_create_by(
      external_uid: ical_event.uid.to_s
    ) do |event|
      event.title = ical_event.summary.to_s
      event.description = ical_event.description.to_s
      event.starts_at = ical_event.dtstart
      event.ends_at = ical_event.dtend || ical_event.dtstart + 2.hours
      event.location = find_or_create_location(ical_event.location)
      event.user = @default_user
    end
  rescue => e
    Rails.logger.error "Failed to import event: #{e.message}"
    nil
  end

  def find_or_create_location(location_string)
    return @default_city.locations.first if location_string.blank?
    
    Location.find_or_create_by(name: location_string.to_s.truncate(128)) do |loc|
      loc.city = @default_city
      loc.street = "Unbekannt"
      loc.zip = "00000"
    end
  end
end
```

### Controller

```ruby
# app/controllers/imports_controller.rb
class ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    file = params[:ical_file]
    city = City.find(params[:city_id])
    
    importer = IcalImporter.new(file.read, default_city: city, default_user: current_user)
    events = importer.import
    
    redirect_to events_path, notice: "#{events.count} Events importiert!"
  end
end
```

### Potentielle Quellen
- Google Calendar (Export als .ics)
- Outlook Calendar
- Apple Calendar
- Meetup (iCal Feed pro Gruppe)

---

## 2. JSON/API Import (Priorität: Mittel)

### Eventbrite API

```ruby
# app/services/eventbrite_importer.rb
class EventbriteImporter
  BASE_URL = "https://www.eventbriteapi.com/v3"

  def initialize(api_token)
    @api_token = api_token
  end

  def import_events(city:, limit: 50)
    response = fetch_events(city, limit)
    response["events"].map { |data| create_event(data) }
  end

  private

  def fetch_events(city, limit)
    uri = URI("#{BASE_URL}/events/search/")
    uri.query = URI.encode_www_form(
      "location.address" => city,
      "location.within" => "25km",
      "expand" => "venue",
      "page_size" => limit
    )

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{@api_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def create_event(data)
    Event.find_or_create_by(external_uid: "eventbrite:#{data['id']}") do |event|
      event.title = data["name"]["text"]
      event.description = data.dig("description", "text") || ""
      event.starts_at = DateTime.parse(data["start"]["utc"])
      event.ends_at = DateTime.parse(data["end"]["utc"])
      event.location = find_or_create_venue(data["venue"])
      event.user = User.find_by(email: "import@eventicus.de")
      event.category = guess_category(data["category_id"])
    end
  end
end
```

### Meetup API (GraphQL)

```ruby
# app/services/meetup_importer.rb
class MeetupImporter
  GRAPHQL_URL = "https://api.meetup.com/gql"

  def import_events(city:, topic: "tech")
    query = <<~GRAPHQL
      query {
        searchEvents(filter: {
          query: "#{topic}"
          lat: #{city.latitude}
          lon: #{city.longitude}
          radius: 25
        }, first: 50) {
          edges {
            node {
              id
              title
              description
              dateTime
              endTime
              venue {
                name
                address
                city
              }
            }
          }
        }
      }
    GRAPHQL

    response = HTTParty.post(GRAPHQL_URL, body: { query: query }.to_json)
    # Process response...
  end
end
```

---

## 3. Web Scraping (Priorität: Niedrig)

### ⚠️ Rechtliche Hinweise
- Immer robots.txt beachten
- Terms of Service prüfen
- Rate Limiting einhalten
- Nur öffentliche Daten scrapen

### Beispiel: Scraping mit Nokogiri

```ruby
# app/services/web_scraper.rb
class WebScraper
  def initialize(url)
    @url = url
    @doc = Nokogiri::HTML(URI.open(url))
  end

  def extract_events
    # Beispiel für JSON-LD Extraktion (Schema.org)
    json_ld = @doc.css('script[type="application/ld+json"]')
    
    json_ld.map do |script|
      data = JSON.parse(script.text)
      next unless data["@type"] == "Event"
      
      {
        title: data["name"],
        description: data["description"],
        starts_at: DateTime.parse(data["startDate"]),
        ends_at: data["endDate"] ? DateTime.parse(data["endDate"]) : nil,
        location_name: data.dig("location", "name"),
        url: data["url"]
      }
    end.compact
  end
end
```

---

## 4. RSS Feed Import

### Implementierung

```ruby
# app/services/rss_importer.rb
require "rss"

class RssImporter
  def initialize(feed_url)
    @feed = RSS::Parser.parse(URI.open(feed_url).read)
  end

  def import
    @feed.items.map do |item|
      create_event_from_item(item)
    end
  end

  private

  def create_event_from_item(item)
    # RSS items don't have structured event data,
    # so we need heuristics or additional parsing
    {
      title: item.title,
      description: item.description,
      url: item.link,
      published_at: item.pubDate
    }
  end
end
```

---

## 5. Manueller Bulk Import (CSV/Excel)

### CSV Format

```csv
title,description,starts_at,ends_at,location_name,category
"Konzert XY","Beschreibung...","2026-02-15 20:00","2026-02-15 23:00","Fabrik","Konzert"
```

### Implementierung

```ruby
# app/services/csv_importer.rb
require "csv"

class CsvImporter
  def initialize(file_path, city:, user:)
    @csv = CSV.read(file_path, headers: true)
    @city = city
    @user = user
  end

  def import
    @csv.map do |row|
      create_event(row)
    end
  end

  private

  def create_event(row)
    location = Location.find_or_create_by!(name: row["location_name"], city: @city) do |l|
      l.street = row["street"] || "Unbekannt"
      l.zip = row["zip"] || "00000"
    end

    category = Category.find_by(name: row["category"])

    Event.create!(
      title: row["title"],
      description: row["description"],
      starts_at: DateTime.parse(row["starts_at"]),
      ends_at: DateTime.parse(row["ends_at"]),
      location: location,
      category: category,
      user: @user
    )
  end
end
```

---

## 6. Automatischer Feed-Import (Cron)

### Rake Task

```ruby
# lib/tasks/import.rake
namespace :import do
  desc "Import events from configured feeds"
  task feeds: :environment do
    ImportFeed.active.each do |feed|
      case feed.feed_type
      when "ical"
        IcalImporter.new(URI.open(feed.url).read, default_city: feed.city, default_user: feed.user).import
      when "eventbrite"
        EventbriteImporter.new(feed.api_token).import_events(city: feed.city.name)
      end
      
      feed.update(last_imported_at: Time.current)
    end
  end
end
```

### Cron Setup (mit whenever gem)

```ruby
# config/schedule.rb
every 6.hours do
  rake "import:feeds"
end
```

---

## Datenbank-Erweiterungen für Import

### Migration für externe IDs

```ruby
class AddExternalFieldsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :external_uid, :string
    add_column :events, :external_source, :string
    add_column :events, :external_url, :string
    add_index :events, [:external_source, :external_uid], unique: true
  end
end
```

### Import Feed Model

```ruby
class ImportFeed < ApplicationRecord
  belongs_to :city
  belongs_to :user
  
  enum :feed_type, { ical: 0, rss: 1, eventbrite: 2, meetup: 3 }
  
  scope :active, -> { where(active: true) }
  scope :due, -> { where("last_imported_at < ? OR last_imported_at IS NULL", 6.hours.ago) }
end
```

---

## Nächste Schritte

1. **Phase 1:** iCal Import UI implementieren
2. **Phase 2:** CSV Import für Bulk-Daten
3. **Phase 3:** Eventbrite/Meetup API Integration (optional)
4. **Phase 4:** Automatischer Cron-Import

---

*Erstellt von Kit 🦊*
