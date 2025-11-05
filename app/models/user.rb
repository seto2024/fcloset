class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  belongs_to :theme, optional: true
  has_many :favorites, dependent: :destroy
  has_many :favorite_items, through: :favorites, source: :item
end
