class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :items

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true 
end
