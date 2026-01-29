class ApplicationController < ActionController::Base
  include Pagy::Backend

  around_action :switch_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def switch_locale(&action)
    locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_accept_language_header
    request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^[a-z]{2}/)&.first&.to_sym
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :time_zone, :avatar, :bio])
  end
end
