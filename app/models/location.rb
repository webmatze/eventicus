class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Geocoding
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj) { obj.should_geocode? }

  # Associations
  belongs_to :city
  has_many :events, dependent: :nullify

  # Validations
  validates :name, presence: true
  validates :street, presence: true
  validates :zip, presence: true
  validates :name, uniqueness: { scope: :city_id }

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }

  def full_address
    [street, "#{zip} #{city.name}", city.country].compact.join(", ")
  end

  def short_address
    [street, city.name].compact.join(", ")
  end

  def coordinates
    [latitude, longitude] if geocoded?
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

  def should_geocode?
    (street_changed? || zip_changed? || city_id_changed?) && latitude.blank?
  end
end
