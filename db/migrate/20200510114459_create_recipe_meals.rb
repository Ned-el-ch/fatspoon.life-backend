class CreateRecipeMeals < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_meals do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :planned_date

      t.timestamps
    end
  end
end
