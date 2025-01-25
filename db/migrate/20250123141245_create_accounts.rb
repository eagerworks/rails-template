class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.references :owner, foreign_key: { to_table: :users }
      t.boolean :personal, default: false

      t.timestamps
    end

    create_table :account_users do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, default: 0
    end
  end
end
