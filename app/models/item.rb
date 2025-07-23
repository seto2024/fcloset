class Item < ApplicationRecord
belongs_to :user
has_one_attached :image 
CATEGORIES = ['トップス', 'パンツ', 'スカート', 'ワンピース', 'コート', '小物', 'アクセサリー', 'バッグ', '靴']
COLORS = ['白', '黒', 'グレー', '赤', '青', '緑', '黄', 'ピンク', 'ベージュ', 'ブラウン']
  
validate :name_or_image_present

private

  def name_or_image_present
    if name.blank? && !image.attached?
      errors.add(:base, "名前または画像のいずれかは必須です")
    end
  end
end