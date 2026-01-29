class EventsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :attend, :unattend]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :attend, :unattend]
  before_action :authorize_event!, only: [:edit, :update, :destroy]

  def index
    @events = Event.includes(:location, :category, :user, location: :city)
    @events = filter_events(@events)
    @pagy, @events = pagy(@events, limit: 20)
  end

  def show
    @event.increment_popularity!
    @comments = @event.comments.oldest_first.includes(:user)
    @attending = current_user&.attending?(@event)
  end

  def new
    @event = current_user.events.build(
      starts_at: 1.week.from_now.change(hour: 19, min: 0),
      ends_at: 1.week.from_now.change(hour: 22, min: 0)
    )
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: t("flash.event_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: t("flash.event_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: t("flash.event_deleted")
  end

  def attend
    attendance = current_user.attendances.find_or_create_by(event: @event)
    if attendance.persisted?
      respond_to do |format|
        format.html { redirect_to @event, notice: t("flash.attendance_created") }
        format.turbo_stream
      end
    else
      redirect_to @event, alert: attendance.errors.full_messages.to_sentence
    end
  end

  def unattend
    current_user.attendances.find_by(event: @event)&.destroy
    respond_to do |format|
      format.html { redirect_to @event, notice: t("flash.attendance_deleted") }
      format.turbo_stream { render :attend }
    end
  end

  private

  def set_event
    @event = Event.friendly.find(params[:id])
  end

  def authorize_event!
    redirect_to @event, alert: "Not authorized" unless @event.user == current_user
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at,
                                   :location_id, :category_id, :cover_image)
  end

  def filter_events(events)
    events = events.upcoming unless params[:filter] == "past" || params[:filter] == "all"
    events = events.past if params[:filter] == "past"
    events = events.in_category(Category.friendly.find(params[:category])) if params[:category].present?
    events = events.in_city(City.friendly.find(params[:city])) if params[:city].present?
    events = events.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    events
  end
end
