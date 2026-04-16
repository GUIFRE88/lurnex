class Invite < ApplicationRecord
  belongs_to :organization
  belongs_to :invited_by_membership, class_name: "Membership"

  enum :role, { admin: 0, student: 1 }, default: :student

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, :token, :role, presence: true
  validates :token, uniqueness: true

  scope :pending, -> { where(accepted_at: nil) }

  before_validation :ensure_token, on: :create

  def accept_for!(user)
    Membership.find_or_create_by!(organization:, user:) do |membership|
      membership.role = role
    end
    update!(accepted_at: Time.current)
  end

  private
    def ensure_token
      self.token ||= SecureRandom.urlsafe_base64(24)
    end
end
