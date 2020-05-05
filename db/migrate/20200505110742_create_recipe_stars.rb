class CreateRecipeStars < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_stars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
