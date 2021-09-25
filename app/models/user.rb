class User < ApplicationRecord
  has_secure_password

  before_save :format_username
  before_save :format_email

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_movies, through: :favourites, source: :movie

  validates :name, presence: true

  validates :username, presence: true,
                       format: { with: /\A[A-Z0-9]+\z/i },
                       uniqueness: { case_sensitive: false }

  validates :email, format: { with: /\S+@\S+/ },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 10, allow_blank: true }

  scope :by_name, -> { order(name: :asc) }
  scope :not_admins, -> { by_name.where(admin: :false) }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    username
  end

  private

  def format_username
    self.username = username.downcase
  end

  def format_email
    self.email = email.downcase
  end
end
