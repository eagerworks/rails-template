class AddStripeIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :stripe_id, :string
  end
end
