class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  has_many :events, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: true

  # Scopes
  scope :ordered, -> { order(:position, :name) }
  scope :with_events, -> { joins(:events).distinct }

  def event_count
    events.upcoming.count
  end
end
