class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :brand
      t.string :category
      t.integer :price

      t.timestamps
    end
  end
end
