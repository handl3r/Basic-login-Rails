class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 20 }

  has_secure_password
  validates :password, presence: true, length: { minimum: 3 }

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def save_remember_token
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticate_remember_token?(remember_token)
    if remember_digest.nil?
      false
    else
      BCrypt::Password.new(remember_digest).is_password? remember_token
    end
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
