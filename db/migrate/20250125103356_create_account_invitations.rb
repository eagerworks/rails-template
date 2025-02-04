class CreateAccountInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :account_invitations do |t|
      t.string :token
      t.references :account, null: false, foreign_key: true
      t.references :invited_by, null: false, foreign_key: { to_table: :users }
      t.string :name
      t.string :email
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
