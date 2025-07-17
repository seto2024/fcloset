class Item < ApplicationRecord
    has_one_attached :image 
  
    validates :name, presence: true
    # 他のバリデーションもここに
  end
