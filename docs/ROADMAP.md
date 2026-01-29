# Eventicus Roadmap 🗺️

**Stand:** 2026-01-29
**Status:** MVP in Entwicklung

---

## 🎯 Vision

Eventicus soll die beste lokale Event-Community-Plattform werden – einfach zu nutzen, schnell, und mit Fokus auf echte lokale Events statt kommerzieller Großveranstaltungen.

---

## 📊 Aktueller Stand

### ✅ Fertig
- Rails 8 Grundstruktur
- Datenmodell (User, Event, Location, City, Category, Attendance, Comment)
- Devise Authentication
- i18n (DE/EN)
- Tailwind CSS Layout
- Events Index mit Karten-Design
- Basic Seeding

### 🚧 In Arbeit
- Vollständige CRUD Views
- UX Verbesserungen

### ❌ Offen
- Suche
- Feeds (RSS/iCal)
- User Profiles
- Maps
- Admin-Bereich
- und vieles mehr...

---

## 🚀 Feature Roadmap

### Phase 1: Core MVP (Priorität: Hoch)

#### 1.1 Vollständige Event CRUD
- [ ] Event Show Page mit allen Details
- [ ] Event Create/Edit Forms
- [ ] Event Delete mit Confirmation
- [ ] Cover Image Upload
- [ ] Attend/Unattend mit Turbo Streams

#### 1.2 User Experience
- [ ] User Profile Page
- [ ] User Settings (Avatar, Timezone, etc.)
- [ ] "Meine Events" (erstellt + teilgenommen)
- [ ] Flash Messages mit Auto-Dismiss

#### 1.3 Navigation & Discovery
- [ ] City Show Page mit Events
- [ ] Category Show Page mit Events
- [ ] Location Show Page mit Events + Map
- [ ] Breadcrumbs

#### 1.4 Feeds
- [ ] RSS Feed für Events (global + per City)
- [ ] iCal Export (einzelne Events + Listen)
- [ ] OpenGraph Meta Tags für Social Sharing

### Phase 2: Enhanced Features (Priorität: Mittel)

#### 2.1 Suche & Filter
- [ ] Volltextsuche (pg_search oder SQLite FTS)
- [ ] Filter kombinieren (Stadt + Kategorie + Zeitraum)
- [ ] Datumsbereich-Filter (heute, diese Woche, diesen Monat)
- [ ] URL-basierte Filter (shareable)

#### 2.2 Karten-Integration
- [ ] Leaflet/MapLibre für Locations
- [ ] Cluster-Ansicht für viele Events
- [ ] "Events in meiner Nähe" (Geolocation)

#### 2.3 Kommentare & Interaktion
- [ ] Kommentare auf Events
- [ ] Kommentar-Benachrichtigungen
- [ ] @mentions in Kommentaren

#### 2.4 Notifications
- [ ] Email bei Event-Änderungen (für Attendees)
- [ ] Erinnerung vor Event-Start
- [ ] Wöchentlicher Digest (opt-in)

### Phase 3: Community Features (Priorität: Niedrig)

#### 3.1 Social Features
- [ ] User Following
- [ ] Event Sharing
- [ ] Event Series (wiederkehrende Events)

#### 3.2 Veranstalter-Features
- [ ] Veranstalter-Profile
- [ ] Mehrere Admins pro Event
- [ ] Event-Statistiken

#### 3.3 Gamification (optional)
- [ ] Badges für aktive User
- [ ] "Event-Entdecker" Achievements
- [ ] Leaderboard pro Stadt

### Phase 4: Admin & Operations

#### 4.1 Admin-Bereich
- [ ] Dashboard mit Statistiken
- [ ] User-Verwaltung
- [ ] Event-Moderation
- [ ] Spam-Erkennung

#### 4.2 SEO & Performance
- [ ] Sitemap.xml
- [ ] robots.txt
- [ ] Structured Data (JSON-LD)
- [ ] Caching-Strategie

#### 4.3 Analytics
- [ ] Event-Views tracken
- [ ] Populäre Kategorien/Städte
- [ ] User-Aktivität

---

## 🎨 UX Verbesserungen

### Navigation
- [ ] Mobile Hamburger Menu
- [ ] Sticky Header bei Scroll
- [ ] Quick Actions (+ Event Button immer sichtbar)
- [ ] Keyboard Shortcuts (j/k für Navigation)

### Event Cards
- [ ] Hover-Effekte verbessern
- [ ] Skeleton Loading States
- [ ] Infinite Scroll Option
- [ ] List vs. Grid View Toggle

### Forms
- [ ] Inline Validation
- [ ] Auto-Save Drafts
- [ ] Location Autocomplete
- [ ] Datum/Zeit-Picker verbessern

### Feedback
- [ ] Toast Notifications
- [ ] Loading Indicators
- [ ] Empty States mit Illustration
- [ ] Error Pages (404, 500) designen

### Accessibility
- [ ] ARIA Labels
- [ ] Keyboard Navigation
- [ ] Screen Reader Testing
- [ ] Contrast Ratio prüfen

---

## 🌱 Seeding & Test-Daten

### Faker-basiertes Seeding
- [ ] Gem hinzufügen: `faker`
- [ ] Konfigurierbare Anzahl (ENV variable)
- [ ] Realistische deutsche Städte/Locations
- [ ] Verschiedene Event-Typen
- [ ] User mit verschiedenen Aktivitätslevels

### Demo-Modus
- [ ] Reset-Button für Demo-Daten
- [ ] Seed-Task mit Optionen: `rails db:seed:demo EVENTS=100`

---

## 📥 Daten-Import

### Potentielle Quellen

#### 1. Öffentliche Event-APIs
- **Eventbrite API** – Große Events, kommerziell
- **Meetup API** – Tech/Hobby Events
- **Facebook Events** – Schwierig (API-Einschränkungen)

#### 2. Lokale Quellen (Hamburg)
- **hamburg.de/veranstaltungen** – Scraping möglich
- **Szene Hamburg** – RSS Feed?
- **Clubs/Venues Websites** – Individuelles Scraping

#### 3. Kalender-Formate
- **iCal Import** – Universell
- **Google Calendar** – API verfügbar
- **Outlook Calendar** – API verfügbar

#### 4. Strukturierte Daten
- **JSON-LD auf Event-Websites** – Scraping mit Schema.org
- **Open Data Portale** – Städtische Veranstaltungen

### Import-Strategie
1. **Phase 1:** Manueller iCal-Import
2. **Phase 2:** Automatischer Feed-Import (Cron)
3. **Phase 3:** API-Integrationen
4. **Phase 4:** Web-Scraping (rechtlich prüfen!)

---

## 🛠️ Technische Verbesserungen

### Performance
- [ ] N+1 Query Fixes (bullet gem)
- [ ] Counter Caches (attendee_count)
- [ ] Fragment Caching
- [ ] Eager Loading optimieren

### Code Quality
- [ ] RSpec statt Minitest
- [ ] Factory Bot für Tests
- [ ] Rubocop Konfiguration
- [ ] GitHub Actions CI

### Security
- [ ] Rate Limiting
- [ ] CAPTCHA für Signup
- [ ] Content Security Policy
- [ ] Dependency Scanning

### Monitoring
- [ ] Error Tracking (Sentry/Honeybadger)
- [ ] Performance Monitoring
- [ ] Uptime Monitoring

---

## 📅 Meilensteine

### M1: Lauffähiges MVP (KW 5)
- Alle CRUD Operationen
- Basic User Profiles
- Deployment auf Server

### M2: Public Beta (KW 8)
- Suche funktioniert
- Feeds implementiert
- 1000+ Seed Events
- Feedback-Sammlung

### M3: Community Launch (KW 12)
- Import aus externen Quellen
- Admin-Bereich
- SEO optimiert
- Marketing-Ready

---

*Erstellt von Kit 🦊*
