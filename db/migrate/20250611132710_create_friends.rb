class CreateFriends < ActiveRecord::Migration[8.0]
  def change
    create_table :friends do |t|
      t.string :name
      t.text :description
      t.date :birth_date
      t.references :user, null: false, foreign_key: true
      t.boolean :best_friend
      t.integer :awards
      t.float :height
      t.integer :gender

      t.timestamps
    end
  end
end
