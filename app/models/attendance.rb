class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id, message: "is already attending this event" }

  # Callbacks
  after_create :increment_event_popularity
  after_destroy :decrement_event_popularity

  private

  def increment_event_popularity
    event.increment_popularity!(5)
  end

  def decrement_event_popularity
    event.increment_popularity!(-5)
  end
end
