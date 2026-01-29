# Demo data generator using Faker
# Run with: rails db:seed:demo USERS=20 EVENTS=100
# Or: rails db:seed:demo (uses defaults)

require "faker"

module Seeds
  class DemoData
    DEFAULT_USERS = 20
    DEFAULT_EVENTS = 100

    EVENT_TITLE_TEMPLATES = {
      "Konzert" => [
        "%{artist} Live",
        "%{artist} Konzert",
        "%{artist} Tour 2026",
        "%{genre} Night",
        "%{genre} Festival",
        "Open Air: %{artist}",
        "%{artist} unplugged"
      ],
      "Party" => [
        "%{genre} Night",
        "%{day} Club Night",
        "House of %{theme}",
        "%{theme} Party",
        "Disco Inferno",
        "Neon Nights",
        "%{day} Fever"
      ],
      "Konferenz" => [
        "%{topic}Conf 2026",
        "%{topic} Summit",
        "%{topic} Meetup",
        "Future of %{topic}",
        "%{topic} Unconference",
        "%{topic} Exchange"
      ],
      "Workshop" => [
        "%{skill} für Einsteiger",
        "%{skill} Masterclass",
        "Hands-on %{skill}",
        "%{skill} Workshop",
        "Learn %{skill}",
        "%{skill} Basics"
      ],
      "Sport" => [
        "%{sport} Turnier",
        "%{sport} Cup",
        "%{sport} für Alle",
        "Open %{sport}",
        "%{sport} Meetup"
      ],
      "Comedy" => [
        "%{comedian} Live",
        "Stand-Up Night",
        "Comedy Club",
        "Lach mal wieder",
        "Open Mic Comedy",
        "%{comedian}: Die Show"
      ],
      "Theater" => [
        "%{play}",
        "%{author}: %{play}",
        "Premiere: %{play}",
        "%{play} - Neuinszenierung"
      ]
    }.freeze

    GENRES = %w[Indie Rock Pop Electronic Techno House Jazz Soul Funk Hip-Hop Metal Punk Reggae].freeze
    ARTISTS = ["Die Ärzte", "Bilderbuch", "AnnenMayKantereit", "Kraftwerk", "Fettes Brot", "Deichkind", "Tocotronic", "Kettcar", "Von Wegen Lisbeth", "Giant Rooks"].freeze
    TOPICS = %w[Tech Ruby Rails AI Design UX Product Data Security Cloud DevOps].freeze
    SKILLS = ["Fotografie", "Malerei", "Kochen", "Yoga", "Meditation", "Keramik", "Programmieren", "Schreiben", "Musik", "Tanz"].freeze
    SPORTS = %w[Fußball Basketball Volleyball Tennis Tischtennis Badminton Yoga Laufen Schwimmen].freeze
    COMEDIANS = ["Carolin Kebekus", "Felix Lobrecht", "Hazel Brugger", "Torsten Sträter", "Chris Tall", "Özcan Cosar"].freeze
    PLAYS = ["Hamlet", "Faust", "Die Räuber", "Woyzeck", "Der Besuch der alten Dame", "Warten auf Godot", "Die Physiker"].freeze
    AUTHORS = ["Shakespeare", "Goethe", "Schiller", "Büchner", "Dürrenmatt", "Beckett"].freeze
    DAYS = %w[Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag].freeze
    THEMES = %w[Tropical Retro Neon Glitter Cosmic Vintage Future].freeze

    def self.call(users: nil, events: nil)
      new(users: users, events: events).call
    end

    def initialize(users: nil, events: nil)
      @user_count = users || ENV.fetch("USERS", DEFAULT_USERS).to_i
      @event_count = events || ENV.fetch("EVENTS", DEFAULT_EVENTS).to_i
    end

    def call
      puts "Generating demo data..."
      puts "  Users: #{@user_count}, Events: #{@event_count}"

      Faker::Config.locale = "de"

      create_users
      create_events
      create_attendances
      create_comments

      puts "Demo data generation complete!"
      print_stats
    end

    private

    def create_users
      # Create demo user first
      @demo_user = User.find_or_create_by!(email: "demo@eventicus.de") do |u|
        u.username = "demo"
        u.password = "password123"
        u.password_confirmation = "password123"
        u.first_name = "Demo"
        u.last_name = "User"
      end

      # Create random users
      @user_count.times do |i|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        username = "#{first_name.downcase}#{rand(100..999)}"

        User.create!(
          email: Faker::Internet.unique.email(name: "#{first_name} #{last_name}"),
          username: username,
          password: "password123",
          password_confirmation: "password123",
          first_name: first_name,
          last_name: last_name,
          time_zone: "Berlin"
        )
      rescue ActiveRecord::RecordInvalid => e
        puts "  ⚠ Skipped user: #{e.message}"
      end

      @users = User.all.to_a
      puts "  ✓ Created #{User.count} users"
    end

    def create_events
      categories = Category.all.to_a
      locations = Location.all.to_a

      return puts "  ⚠ No locations found, skipping events" if locations.empty?

      Location.skip_callback(:validation, :after, :geocode)

      @event_count.times do |i|
        category = categories.sample
        location = locations.sample
        user = @users.sample

        # Generate time: 70% future, 20% past, 10% today
        rand_val = rand(100)
        if rand_val < 70
          starts_at = rand(1..90).days.from_now + rand(0..23).hours
        elsif rand_val < 90
          starts_at = rand(1..60).days.ago + rand(0..23).hours
        else
          starts_at = Time.current.change(hour: rand(14..22))
        end

        # Duration: 1-6 hours typically
        duration = [1, 2, 3, 4, 5, 6, 8, 12].sample.hours
        ends_at = starts_at + duration

        title = generate_title(category.name)
        description = generate_description(category.name, title)

        Event.create!(
          title: title,
          description: description,
          starts_at: starts_at,
          ends_at: ends_at,
          user: user,
          location: location,
          category: category,
          popularity: rand(0..100)
        )
      rescue ActiveRecord::RecordInvalid => e
        puts "  ⚠ Skipped event: #{e.message}"
      end

      Location.set_callback(:validation, :after, :geocode)
      puts "  ✓ Created #{Event.count} events"
    end

    def create_attendances
      events = Event.all.to_a
      
      events.each do |event|
        # 0-15 random attendees per event
        attendee_count = rand(0..15)
        attendees = @users.sample(attendee_count)

        attendees.each do |user|
          Attendance.find_or_create_by!(user: user, event: event)
        rescue ActiveRecord::RecordInvalid
          # Skip duplicates
        end
      end

      puts "  ✓ Created #{Attendance.count} attendances"
    end

    def create_comments
      events = Event.all.sample(Event.count / 3) # Comment on 1/3 of events

      events.each do |event|
        comment_count = rand(0..5)
        
        comment_count.times do
          Comment.create!(
            commentable: event,
            user: @users.sample,
            body: generate_comment
          )
        end
      end

      puts "  ✓ Created #{Comment.count} comments"
    end

    def generate_title(category_name)
      templates = EVENT_TITLE_TEMPLATES[category_name] || ["%{theme} Event"]
      template = templates.sample

      template % {
        artist: ARTISTS.sample,
        genre: GENRES.sample,
        topic: TOPICS.sample,
        skill: SKILLS.sample,
        sport: SPORTS.sample,
        comedian: COMEDIANS.sample,
        play: PLAYS.sample,
        author: AUTHORS.sample,
        day: DAYS.sample,
        theme: THEMES.sample
      }
    end

    def generate_description(category_name, title)
      intro = [
        "Erlebe #{title} live!",
        "#{title} – ein Abend, den du nicht verpassen solltest.",
        "Wir laden ein zu #{title}.",
        "#{title} kommt in die Stadt!",
        "Sei dabei bei #{title}."
      ].sample

      body = Faker::Lorem.paragraphs(number: rand(2..4)).join("\n\n")
      
      outro = [
        "Tickets an der Abendkasse verfügbar.",
        "Einlass ab 18 Jahren.",
        "Kommt zahlreich!",
        "Wir freuen uns auf euch!",
        "Getränke vor Ort erhältlich."
      ].sample

      "#{intro}\n\n#{body}\n\n#{outro}"
    end

    def generate_comment
      [
        "Bin dabei! 🎉",
        "Klingt super, wer kommt noch?",
        "War letztes Mal auch schon da, kann ich nur empfehlen!",
        "Wie ist die Anfahrt mit den Öffis?",
        "Freue mich drauf!",
        "Hat jemand noch ein Ticket über?",
        "Mega Location!",
        Faker::Lorem.sentence(word_count: rand(5..15)),
        "Super! 👍",
        "Endlich mal wieder was los hier!"
      ].sample
    end

    def print_stats
      puts "\n📊 Database Stats:"
      puts "   Users:       #{User.count}"
      puts "   Events:      #{Event.count}"
      puts "   Attendances: #{Attendance.count}"
      puts "   Comments:    #{Comment.count}"
      puts "   Locations:   #{Location.count}"
      puts "   Cities:      #{City.count}"
      puts "   Categories:  #{Category.count}"
    end
  end
end
