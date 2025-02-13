class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.integer :quantity
      t.datetime :trial_ends_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
