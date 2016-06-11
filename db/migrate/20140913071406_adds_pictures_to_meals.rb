class AddsPicturesToMeals < ActiveRecord::Migration
  def up
    add_attachment :meals, :picture
  end

  def down
    remove_attachment :meals, :picture
  end
end
