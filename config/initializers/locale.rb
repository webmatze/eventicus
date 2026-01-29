# Internationalization configuration for Eventicus
# Available locales: German (default) and English

Rails.application.config.i18n.available_locales = [:de, :en]
Rails.application.config.i18n.default_locale = :de
Rails.application.config.i18n.fallbacks = true
Rails.application.config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
