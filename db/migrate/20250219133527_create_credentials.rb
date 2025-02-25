class CreateCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :credentials do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.string :webauthn_id, null: false, index: { unique: true }
      t.string :public_key, null: false
      t.integer :sign_count, default: 0

      t.timestamps
    end
  end
end
