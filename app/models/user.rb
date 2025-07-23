class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true 
end
