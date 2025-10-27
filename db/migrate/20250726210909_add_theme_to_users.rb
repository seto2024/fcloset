class AddThemeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :theme, foreign_key: true, null: true
  end
end
