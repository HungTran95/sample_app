class User < ApplicationRecord
  VALID_EMAIL_REGEX = [/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i].freeze
  validates :email, presence: true,
    length: {maximum: Settings.email_max_length},
    uniqueness: {case_sensitive: false},
    format: {with: VALID_EMAIL_REGEX}
  validates :name, presence: true,
    length: {maximum: Settings.name_max_length}
  validates :password, presence: true,
    length: {maximum: Settings.pass_max_length}

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
  has_secure_password
end
