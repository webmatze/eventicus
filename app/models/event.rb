class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Associations
  belongs_to :user
  belongs_to :location
  belongs_to :category, optional: true
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, source: :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_one_attached :cover_image

  # Delegations
  delegate :city, to: :location

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ends_after_starts

  # Callbacks
  before_create :set_default_popularity

  # Scopes
  scope :upcoming, -> { where("starts_at > ?", Time.current).order(starts_at: :asc) }
  scope :past, -> { where("ends_at < ?", Time.current).order(starts_at: :desc) }
  scope :today, -> { where(starts_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :this_week, -> { where(starts_at: Time.current.beginning_of_week..Time.current.end_of_week) }
  scope :this_month, -> { where(starts_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :popular, -> { order(popularity: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :in_city, ->(city) { joins(:location).where(locations: { city_id: city.id }) }
  scope :in_category, ->(category) { where(category_id: category.id) }

  def happening_now?
    starts_at <= Time.current && ends_at >= Time.current
  end

  def upcoming?
    starts_at > Time.current
  end

  def past?
    ends_at < Time.current
  end

  def duration_in_hours
    ((ends_at - starts_at) / 1.hour).round(1)
  end

  def increment_popularity!(amount = 1)
    increment!(:popularity, amount)
  end

  def attendee_count
    attendees.count
  end

  # iCal export
  def to_ical_event
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new(starts_at)
    event.dtend = Icalendar::Values::DateTime.new(ends_at)
    event.summary = title
    event.description = description
    event.location = location.full_address
    event.uid = "event-#{id}@eventicus.de"
    event.created = Icalendar::Values::DateTime.new(created_at)
    event.last_modified = Icalendar::Values::DateTime.new(updated_at)

    if location.geocoded?
      event.geo = Icalendar::Values::Geo.new([location.latitude, location.longitude])
    end

    event
  end

  private

  def ends_after_starts
    return unless starts_at && ends_at
    errors.add(:ends_at, "must be after start time") if ends_at <= starts_at
  end

  def set_default_popularity
    self.popularity ||= 0
  end
end
