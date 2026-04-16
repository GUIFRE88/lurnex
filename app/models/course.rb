class Course < ApplicationRecord
  belongs_to :organization
  has_many :enrollments, dependent: :destroy

  validates :title, presence: true
end
