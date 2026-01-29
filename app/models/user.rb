class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :events, dependent: :nullify
  has_many :attendances, dependent: :destroy
  has_many :attended_events, through: :attendances, source: :event
  has_many :comments, dependent: :nullify
  has_one_attached :avatar

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 40 },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only letters, numbers and underscores allowed" }

  # Default timezone
  attribute :time_zone, :string, default: "Berlin"

  def display_name
    if first_name.present? || last_name.present?
      [first_name, last_name].compact.join(" ")
    else
      username
    end
  end

  def attending?(event)
    attended_events.include?(event)
  end
end
