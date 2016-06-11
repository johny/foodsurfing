class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|

      t.string :name
      t.text :description
      t.text :ingredients

      t.datetime :served_at
      t.datetime :cutoff_time

      t.integer :portions
      t.float :price_per_portion

      t.references :user



      t.timestamps
    end
  end
end
