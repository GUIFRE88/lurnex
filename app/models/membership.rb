class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  has_many :invites, foreign_key: :invited_by_membership_id, dependent: :restrict_with_error
  has_many :enrollments, dependent: :destroy

  enum :role, { admin: 0, student: 1 }, default: :student

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :organization_id }
end
