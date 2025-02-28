class User < ApplicationRecord
  attr_accessor :remember_token

  USER_ATTRIBUTES = %i(name email password password_confirmation).freeze
  before_save :downcase_email
  validates :name, presence: true,
            length: {maximum: Settings.max_name_length}
  validates :email, presence: true,
            length: {maximum: Settings.max_email_length},
            format: {with: Regexp.new(Settings.valid_email_regex)},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, allow_nil: true,
            length: {minimum: Settings.min_password_length}
  has_secure_password

  class << self
    def digest string_value
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string_value, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private
  def downcase_email
    email.downcase!
  end
end
