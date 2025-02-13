class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :amount
      t.integer :interval, default: 0
      t.jsonb :details
      t.integer :trial_period_days, default: 0
      t.string :currency, default: 'usd'
      t.string :description
      t.string :unit_label
      t.boolean :charge_per_unit, default: false
      t.string :stripe_id
      t.string :contact_url

      t.timestamps
    end
  end
end
