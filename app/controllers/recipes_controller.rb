class RecipesController < ApplicationController

	skip_before_action :authorized, only: [:show]

	def create
		recipe_exists = Recipe.find_by(uuid: recipe_params[:uuid])
		recipe = Recipe.new
		recipe.title = recipe_params[:title]
		recipe.imageLink = recipe_params[:imageLink]
		recipe.prepTime = recipe_params[:prepTime]
		recipe.cookingTime = recipe_params[:cookingTime]
		recipe.description = recipe_params[:description]
		recipe.instructions = recipe_params[:instructions]
		recipe.uuid = recipe_params[:uuid]
		recipe.servingCount = recipe_params[:servingCount]
		recipe.user = @user
		if !recipe_exists && recipe.save
			ingredients = recipe_params[:ingredients]
			ingredients.each do |ing|
				ingredient_exists = Ingredient.find_by(uuid: ing[:uuid])
				if ingredient_exists
					RecipeIngredient.create(ingredient: ingredient_exists, recipe: recipe, weight: ing[:weight])
				end
			end
			# render json: { recipe: recipe }, status: :accepted
			render json: recipe.to_json(
				only: [:title, :description],
				include: {
					user: {
						only: [:username]
					},
					recipe_ingredients: {
						only: [:weight, :uuid],
						include: {
							ingredient: {
								only: [:uuid]
							}
						}
					}
				}
			), status: :accepted
		else
			render json: { error: 'failed to create recipe' }, status: :not_acceptable
		end
	end

	def show
		recipe = Recipe.find_by(uuid: params[:uuid])
		if recipe
			render json: recipe.to_json(
				only: [:title, :description, :imageLink, :prepTime, :cookingTime, :instructions, :servingCount, :uuid],
				include: {
					user: {
						only: [:username]
					},
					recipe_ingredients: {
						only: [:weight],
						include: {
							ingredient: {
								only: [:uuid]
							}
						}
					}
				}
			), status: :accepted
		else
			render json: { error: 'failed to find recipe' }, status: :not_acceptable
		end
	end

	private
	def recipe_params
		params.require(:recipe).permit(:title, :imageLink, :prepTime, :cookingTime, :description, :instructions, :uuid, :servingCount, {:ingredients => [:uuid, :weight]} )
	end
end