class Recipe < ApplicationRecord

	include PgSearch
	multisearchable :against => [:title, :description, :instructions]
	# pg_search_scope :search_by_term, against: [:title, :description, :instructions],
	# 	using: {
	# 		tsearch: {
	# 			any_word: true,
	# 			prefix: true
	# 		}
	# 	}
	
	belongs_to :user
	has_many :recipe_stars
	has_many :users, through: :recipe_stars
	has_many :recipe_ingredients
	has_many :ingredients, through: :recipe_ingredients
	has_many :recipe_meals
end