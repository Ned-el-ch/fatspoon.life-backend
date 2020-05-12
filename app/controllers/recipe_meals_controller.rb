class RecipeMealsController < ApplicationController

	def meals
		meals = RecipeMeal.where("planned_date >= ? AND planned_date <= ?", :start_date, :end_date)
		if meals && meals.size > 0
			render json: meals.to_json(
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
			render json: { error: 'failed to find meals' }, status: :not_acceptable
		end
	end

	def update_multiplier
		rm = RecipeMeal.find_by(id: meal_params[:id])
		if rm
			rm.update(multiplier: meal_params[:multiplier])
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
			render json: { error: 'failed to find meal' }, status: :not_acceptable
		end
	end

	def destroy
		rm = RecipeMeal.find_by(id: meal_params[:id])
		if rm
			rm.destroy
			render json: { success: 'meal deleted' }, status: :accepted
		else
			render json: { error: 'failed to find meal' }, status: :not_acceptable
		end
	end

	private
	def meal_params
		params.require(:recipe_meal).permit(:id, :start_date, :end_date, :planned_date, :multiplier, {:ingredients => [:uuid, :weight]} )
	end
end