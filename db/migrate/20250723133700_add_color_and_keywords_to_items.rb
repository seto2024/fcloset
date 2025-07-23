class AddColorAndKeywordsToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :color, :string
    add_column :items, :keyword1, :string
    add_column :items, :keyword2, :string
  end
end
