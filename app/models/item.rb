class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image 

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags

  accepts_nested_attributes_for :tags

  CATEGORIES = ['トップス', 'パンツ', 'スカート', 'ワンピース', 'コート', '小物', 'アクセサリー', 'バッグ', '靴', 'その他']
  COLORS = ['ホワイト', 'ブラック', 'グレー', 'レッド', 'ブルー', 'グリーン', 'イエロー', 'ピンク', 'ベージュ', 'ブラウン', 'パープル', 'その他']
  
  validate :name_or_image_present

  private

  def name_or_image_present
    if name.blank? && !image.attached?
      errors.add(:base, "名前または画像のいずれかは必須です")
    end
  end
end

