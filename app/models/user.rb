class User < ApplicationRecord
	has_secure_password
	validates :username, uniqueness: { case_sensitive: false }
	has_many: :recipes
	has_many: :recipe_stars
	has_many: :recipes, through: :recipe_stars
end