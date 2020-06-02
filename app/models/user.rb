class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true,
    length: {maximum: Settings.email_max_length},
    uniqueness: {case_sensitive: false},
    format: {with: VALID_EMAIL_REGEX}
  validates :name, presence: true,
    length: {maximum: Settings.name_max_length}
  validates :password, presence: true,
    length: {maximum: Settings.pass_max_length}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.password_size}, allow_nil: true

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
