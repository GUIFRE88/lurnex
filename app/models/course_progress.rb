class CourseProgress < ApplicationRecord
  belongs_to :enrollment

  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
