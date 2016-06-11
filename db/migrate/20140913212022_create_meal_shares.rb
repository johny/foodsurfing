class CreateMealShares < ActiveRecord::Migration
  def change
    create_table :meal_shares do |t|

      t.belongs_to :user
      t.belongs_to :meal

      t.integer :ordered_portions

      t.string :comment
      t.timestamps

      t.timestamps
    end
  end
end
