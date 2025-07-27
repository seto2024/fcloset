class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image 

  CATEGORIES = ['トップス', 'パンツ', 'スカート', 'ワンピース', 'コート', '小物', 'アクセサリー', 'バッグ', '靴', 'その他']
  COLORS = ['ホワイト', 'ブラック', 'グレー', 'レッド', 'ブルー', 'グリーン', 'イエロー', 'ピンク', 'ベージュ', 'ブラウン', 'パープル', 'その他']
  
  validate :name_or_image_present

  # HEIC画像があったらJPGに変換する
  after_commit :convert_heic_to_jpg, if: -> { image.attached? && image.blob.content_type == "image/heic" }

  private

  def name_or_image_present
    if name.blank? && !image.attached?
      errors.add(:base, "名前または画像のいずれかは必須です")
    end
  end

  def convert_heic_to_jpg
    require "mini_magick"

    return unless image.attached? && image.filename.extension.downcase == "heic"

    Tempfile.open(["converted", ".jpg"]) do |file|
      file.binmode
      file.write(image.download)  # ここでメモリから直接読み込む！
      file.rewind

      image_magick = MiniMagick::Image.new(file.path)
      image_magick.format "jpg"
      image_magick.write(file.path)

      image.purge
      image.attach(io: File.open(file.path), filename: "converted.jpg", content_type: "image/jpeg")
    end
  end
end
