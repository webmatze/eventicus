class City < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  has_many :locations, dependent: :destroy
  has_many :events, through: :locations

  # Validations
  validates :name, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :name, uniqueness: { scope: [:country, :state] }

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :with_events, -> { joins(:events).distinct }

  def full_name
    "#{name}, #{country}"
  end

  def event_count
    events.upcoming.count
  end
end
