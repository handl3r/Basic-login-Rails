class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }

  has_secure_password
  validates :password, presence: true, length: { minimum: 3 }
end
