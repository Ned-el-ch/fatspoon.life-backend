class Recipe < ApplicationRecord
	belongs_to :user
	has_many :recipe_stars
	has_many :users, through: :recipe_stars
	has_many :recipe_ingredients
	has_many :ingredients, through: :recipe_ingredients
end