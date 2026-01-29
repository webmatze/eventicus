# frozen_string_literal: true

module Feeds
  class EventsController < ApplicationController
    # RSS Feeds
    def index
      @events = Event.upcoming.includes(:location, :category, :user, location: :city).limit(50)
      respond_to do |format|
        format.rss { render layout: false }
      end
    end

    def city
      @city = City.friendly.find(params[:city])
      @events = @city.events.upcoming.includes(:location, :category, :user).limit(50)
      respond_to do |format|
        format.rss { render layout: false }
      end
    end

    def category
      @category = Category.friendly.find(params[:category])
      @events = @category.events.upcoming.includes(:location, :category, :user, location: :city).limit(50)
      respond_to do |format|
        format.rss { render layout: false }
      end
    end

    # iCal Feeds
    def ical
      @events = Event.upcoming.includes(:location, :category, location: :city).limit(100)
      respond_to do |format|
        format.ics { render layout: false, content_type: "text/calendar" }
      end
    end

    def city_ical
      @city = City.friendly.find(params[:city])
      @events = @city.events.upcoming.includes(:location, :category).limit(100)
      respond_to do |format|
        format.ics { render layout: false, content_type: "text/calendar" }
      end
    end

    def category_ical
      @category = Category.friendly.find(params[:category])
      @events = @category.events.upcoming.includes(:location, :category, location: :city).limit(100)
      respond_to do |format|
        format.ics { render layout: false, content_type: "text/calendar" }
      end
    end

    def show
      @event = Event.friendly.find(params[:id])
      respond_to do |format|
        format.ics { render layout: false, content_type: "text/calendar" }
      end
    end
  end
end
