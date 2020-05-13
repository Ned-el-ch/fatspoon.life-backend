class SearchController < ApplicationController

	skip_before_action :authorized, only: [:search]

	def search
		recipes = Recipe.search(params[:query])
		if recipes
			render json: recipes.to_json(
				only: [:title, :description, :imageLink, :prepTime, :cookingTime, :instructions, :servingCount, :uuid],
				include: {
					user: {
						only: [:username]
					},
					recipe_ingredients: {
						only: [:weight],
						include: {
							ingredient: {
								only: [:uuid, :name]
							}
						}
					},
					recipe_stars: {
						only: [],
						include: {
							user: {
								only: [:username]
							}
						}
					}
				}
			), status: :accepted
		else
			render json: { error: 'failed to find recipe' }, status: :not_acceptable
		end
	end
end