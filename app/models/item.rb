class Item < ApplicationRecord
    has_one_attached :image 
    CATEGORIES = ['トップス', 'パンツ', 'スカート', 'ワンピース', 'コート', '小物', 'アクセサリー', 'バッグ']
    COLORS = ['白', '黒', 'グレー', '赤', '青', '緑', '黄', 'ピンク', 'ベージュ', 'ブラウン']
  
    validates :name, presence: true
    # 他のバリデーションもここに
  end
