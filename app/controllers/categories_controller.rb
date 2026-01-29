class CategoriesController < ApplicationController
  include Pagy::Backend

  def index
    @categories = Category.ordered.with_events
  end

  def show
    @category = Category.friendly.find(params[:id])
    @events = @category.events.upcoming.includes(:location, :category, location: :city)
    
    # City filter
    if params[:city].present?
      @selected_city = City.friendly.find(params[:city]) rescue nil
      @events = @events.joins(location: :city).where(cities: { id: @selected_city.id }) if @selected_city
    end
    
    @cities = City.joins(:events).where(events: { category_id: @category.id }).distinct.order(:name)
    @pagy, @events = pagy(@events, limit: 12)
  end
end
