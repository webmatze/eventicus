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
    get "events", to: "events#index", defaults: { format: :rss }
    get "events/:city", to: "events#city", defaults: { format: :rss }
    get "ical/events", to: "events#ical", defaults: { format: :ics }
    get "ical/events/:city", to: "events#city_ical", defaults: { format: :ics }
  end

  # Root
  root "events#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
