class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)

  before_save :set_slug

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :fans, -> { order(username: :asc) }, through: :favourites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterisations, dependent: :destroy
  has_many :genres, -> { order(:name) }, through: :characterisations

  has_one_attached :main_image

  validates :title, uniqueness: true, presence: true
  validates :released_on, :duration, presence: true

  validates :description, length: { minimum: 25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates :rating, inclusion: { in: RATINGS }

  validate :acceptable_image

  scope :released, -> { where("released_on <= ?", Date.today).order(released_on: :desc) }
  scope :upcoming, -> { where("released_on > ?", Date.today).order(released_on: :asc) }
  scope :recent, ->(max = 5) { released.limit(max) }
  # scope :recent, lambda { |max=5| released.limit(max) }
  scope :hits, -> { released.where("total_gross >= ?", 300_000_000).order(total_gross: :desc) }
  scope :flops, -> { released.where("total_gross < ?", 255_000_000).order(total_gross: :asc) }
  scope :recently_added, ->(max = 3) { order(created_at: :desc).limit(max) }
  scope :grossed_less_than, ->(amount) { where("total_gross < ?", amount) }
  scope :grossed_greater_than, ->(amount) { where("total_gross > ?", amount) }

  # There is some inconsistency here between the scope logic for flop and this more complicated
  # check for a flop that also considers if it s a cult classic. Could bring them in line as an
  # exercise - can probably do the logic in a scope.
  def flop?
    (total_gross.blank? || total_gross < 255_000_000) && !cult_classic?
  end

  def cult_classic?
    reviews.size > 50 && reviews.average(:stars) >= 4.0
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end

  def acceptable_image
    return unless main_image.attached?

    unless main_image.blob.byte_size <= 1.megabyte
      errors.add(:main_image, "is to big, cannot be greater than 1 megabyte")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(main_image.blob.content_type)
      errors.add(:main_image, "must be a JPEG or PNG")
    end
  end
end
