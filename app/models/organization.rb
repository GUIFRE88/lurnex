class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :courses, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  before_validation :normalize_slug

  private
    def normalize_slug
      self.slug = name.to_s.parameterize if slug.blank?
    end
end
