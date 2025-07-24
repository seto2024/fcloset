class AddFirstLoginToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_login, :boolean, default: true
  end
end
