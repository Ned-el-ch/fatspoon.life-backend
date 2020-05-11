class AddMultiplierToRecipeMeal < ActiveRecord::Migration[6.0]
  def change
    add_column :recipe_meals, :multiplier, :integer
  end
end
