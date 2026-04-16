class Enrollment < ApplicationRecord
  belongs_to :organization
  belongs_to :course
  belongs_to :membership
  has_one :course_progress, dependent: :destroy

  validates :membership_id, uniqueness: { scope: :course_id }
  validate :course_and_membership_in_same_organization
  validate :membership_must_be_student

  private
    def course_and_membership_in_same_organization
      return if course.blank? || membership.blank? || organization.blank?
      return if course.organization_id == organization_id && membership.organization_id == organization_id

      errors.add(:base, "Course and membership must belong to the same organization")
    end

    def membership_must_be_student
      return if membership.blank? || membership.student?

      errors.add(:membership, "must be a student")
    end
end
