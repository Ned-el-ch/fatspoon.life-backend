class AddServingCountToRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :servingCount, :integer
  end
end
