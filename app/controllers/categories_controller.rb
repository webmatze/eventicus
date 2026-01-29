class CategoriesController < ApplicationController
  include Pagy::Backend

  def index
    @categories = Category.ordered.with_events
  end

  def show
    @category = Category.friendly.find(params[:id])
    @events = @category.events.upcoming.includes(:location, :category, location: :city)
    @pagy, @events = pagy(@events, limit: 20)
  end
end
