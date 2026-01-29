Rails.application.routes.draw do
  # Devise routes with locale scope
  devise_for :users

  # Locale-scoped routes
  scope "(:locale)", locale: /en|de/ do
    # Events
    resources :events do
      member do
        post :attend
        delete :unattend
      end
      resources :comments, only: [:create, :destroy], module: :events
    end

    # Locations (Venues)
    resources :locations, only: [:index, :show] do
      resources :events, only: [:index], module: :locations
    end

    # Cities
    resources :cities, only: [:index, :show] do
      resources :events, only: [:index], module: :cities
      resources :locations, only: [:index], module: :cities
    end

    # Categories
    resources :categories, only: [:index, :show] do
      resources :events, only: [:index], module: :categories
    end

    # User profiles
    resources :users, only: [:show], param: :username
  end

  # Feeds (no locale needed)
  namespace :feeds do
    # RSS Feeds
    get "events", to: "events#index", defaults: { format: :rss }, as: :events
    get "events/city/:city", to: "events#city", defaults: { format: :rss }, as: :city
    get "events/category/:category", to: "events#category", defaults: { format: :rss }, as: :category
    
    # iCal Feeds
    get "ical/events", to: "events#ical", defaults: { format: :ics }, as: :ical
    get "ical/events/city/:city", to: "events#city_ical", defaults: { format: :ics }, as: :city_ical
    get "ical/events/category/:category", to: "events#category_ical", defaults: { format: :ics }, as: :category_ical
    get "ical/event/:id", to: "events#show", defaults: { format: :ics }, as: :event_ical
  end

  # Root
  root "events#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
