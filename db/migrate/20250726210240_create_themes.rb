class CreateThemes < ActiveRecord::Migration[7.1]
  def change
    create_table :themes do |t|
      t.string :name
      t.string :css_class

      t.timestamps
    end
  end
end
