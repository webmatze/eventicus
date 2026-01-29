class CitiesController < ApplicationController
  include Pagy::Backend

  def index
    @cities = City.ordered.with_events
    @pagy, @cities = pagy(@cities, limit: 30)
  end

  def show
    @city = City.friendly.find(params[:id])
    @events = @city.events.upcoming.includes(:location, :category)
    @pagy, @events = pagy(@events, limit: 20)
  end
end
