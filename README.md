# Eventicus 🎉

A modern event community platform – rebuilt with Rails 8.

Originally created in 2008 as Mathias Karstädt's first Rails project, **eventicus** is being revived with a modern tech stack while keeping the original spirit: helping people discover and share events in their city.

## 🚀 Tech Stack

- **Rails 8.0** with Hotwire (Turbo + Stimulus)
- **Tailwind CSS** for styling
- **SQLite** with Solid Queue/Cache/Cable
- **Devise** for authentication
- **FriendlyId** for SEO-friendly URLs
- **Geocoder** for location services
- **Pagy** for pagination
- **i18n** (German 🇩🇪 + English 🇬🇧)

## 📋 Features

- ✅ Event listings with filters (upcoming/past/category/city)
- ✅ User registration and profiles
- ✅ Event attendance tracking
- ✅ Comments on events
- ✅ Multiple cities support
- ✅ Categories for events
- ✅ Geocoding for venues
- ✅ RSS feeds
- ✅ iCal export
- ✅ Multilingual (DE/EN)
- ✅ Responsive design
- ⬜ Event search
- ⬜ Map integration
- ⬜ Social sharing

## 🛠️ Development

```bash
# Clone the repository
git clone https://github.com/webmatze/eventicus.git
cd eventicus

# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate db:seed

# Start the server
bin/dev
```

Visit http://localhost:3000

**Demo user:** demo@eventicus.de / password123

## 🌍 Deployment

Eventicus is configured for deployment with [Kamal](https://kamal-deploy.org/).

```bash
# Setup secrets
cp .kamal/secrets.example .kamal/secrets
# Edit .kamal/secrets with your values

# Deploy
kamal setup
kamal deploy
```

## 📜 History

- **2008**: Original eventicus.de created with Rails 2.3
- **2013**: Last update before dormancy
- **2026**: Complete rebuild with Rails 8

## 📄 License

Copyright © 2008-2026 Mathias Karstädt

Licensed under the GNU General Public License v3.0 – see [LICENSE](LICENSE) for details.

---

Made with ❤️ in Hamburg
