class LocationsController < ApplicationController
  include Pagy::Backend

  def index
    @locations = Location.includes(:city).ordered
    @pagy, @locations = pagy(@locations, limit: 30)
  end

  def show
    @location = Location.friendly.find(params[:id])
    @events = @location.events.upcoming.includes(:category, :user)
    @pagy, @events = pagy(@events, limit: 20)
  end
end
