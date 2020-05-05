class RecipesController < ApplicationController
	def create
	end

	private
	def recipe_params
		params.require(:recipe).permit(:title, :imageLink, :prepTime, :cookingTime, :description)
	end
end