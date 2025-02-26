class AddPasswordSetToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_set, :boolean, default: true
  end
end
