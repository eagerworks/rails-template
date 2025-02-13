class AddStatusToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :subscriptions, :status, :integer, default: 0
  end
end
