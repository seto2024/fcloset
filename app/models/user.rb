class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
end
