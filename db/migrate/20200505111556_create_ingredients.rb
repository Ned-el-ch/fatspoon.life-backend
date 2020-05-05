class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :uuid
      t.string :name
      t.string :category
      t.integer :index

      t.timestamps
    end
  end
end
