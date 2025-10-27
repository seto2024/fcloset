class AddPublicToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :public, :boolean
  end
end
