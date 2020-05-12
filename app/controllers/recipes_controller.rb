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
								only: [:uuid, :name]
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

	def star_recipe
		recipe = Recipe.find_by(uuid: recipe_params[:uuid])
		rs = RecipeStar.find_by(recipe: recipe, user: @user)
		if recipe && !rs
			rs = RecipeStar.new
			rs.recipe = recipe
			rs.user = @user
			if rs.save
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
						},
						recipe_meals: {
							only: [:planned_date, :multiplier],
							include: {
								recipe: {
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
	end

	def unstar_recipe
		recipe = Recipe.find_by(uuid: recipe_params[:uuid])
		rs = RecipeStar.find_by(recipe: recipe, user: @user)
		if recipe && rs
			rs.destroy
			render json: { success: 'recipe unstarred' }, status: :accepted
		else
			render json: { error: 'failed to find recipe' }, status: :not_acceptable
		end
	end

	def add_recipe_to_meal_planner
		recipe = Recipe.find_by(uuid: recipe_params[:uuid])
		# byebug
		if recipe
			rm = RecipeMeal.new
			rm.recipe = recipe
			rm.user = @user
			rm.planned_date = recipe_params[:planned_date].to_datetime.strftime('%Y-%m-%d %H:%M:%S')
			rm.multiplier = recipe_params[:multiplier]
			# byebug
			if rm.save
				render json: rm.to_json(
					only: [:id, :multiplier, :planned_date],
					include: {
						recipe: {
							only: [:title, :description, :prepTime, :cookingTime, :servingCount, :imageLink, :instructions, :uuid],
							include: {
								user: {
									only: [:username]
								},
								recipe_ingredients: {
									only: [:weight],
									include: {
										ingredient: {
											only: [:uuid, :name]
										},
										recipe: {
											only: [:uuid]
										}
									}
								},
								recipe_stars: {
									only: [],
									include: {
										recipe: {
											only: [:uuid]
										}
									}
								}
							}
						}
					}
				), status: :accepted
			else
				render json: { error: 'Something else went wrong' }, status: :not_acceptable
			end
		else
			render json: { error: 'failed to find recipe' }, status: :not_acceptable
		end
	end

	def remove_recipe_from_meal_planner
		recipe = Recipe.find_by(uuid: recipe_params[:uuid])
		rm = RecipeMeal.find_by(id: recipe_params[:rmid])
		if rm
			rm.destroy
			render json: { success: 'recipe removed from meal plan' }, status: :accepted
		else
			render json: { error: 'failed to find meal' }, status: :not_acceptable
		end
	end

	private
	def recipe_params
		params.require(:recipe).permit(:rmid, :title, :imageLink, :prepTime, :cookingTime, :description, :instructions, :uuid, :servingCount, :planned_date, :multiplier, {:ingredients => [:uuid, :weight]} )
	end
end