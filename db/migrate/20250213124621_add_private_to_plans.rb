class AddPrivateToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :private, :boolean, default: true
  end
end
