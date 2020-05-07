class Api::V1::UsersController < ApplicationController

	skip_before_action :authorized, only: [:create, :all_recipes]

	def profile
		# render json: { user: UserSerializer.new(current_user) }, status: :accepted
		render json: current_user.to_json(
			only: [:username],
			include: [recipes: {
				only: [:title, :description, :prepTime, :cookingTime, :servingCount, :imageLink, :instructions, :uuid],
				include: {
					user: {
						only: [:username]
					},
					recipe_ingredients: {
						only: [:weight],
						include: {
							ingredient: {
								only: [:uuid]
							},
							recipe: {
								only: [:uuid]
							}
						}
					}
				}
			},
			user_ingredients: {
				only: [:weight],
				include: {
					ingredient: {
						only: [:uuid]
					}
				}
			}
		]
			), status: :accepted
	end

	def create
		@user = User.create(user_params)
		if @user.valid?
			@token = encode_token({ user_id: @user.id })
			render json: {
				token: @token,
				user_data: @user.to_json(
				only: [:username],
				include: [
					user_ingredients: {
						only: [:weight],
						include: {
							ingredient: {
								only: [:uuid]
							}
						}
					},
					recipes: {
						only: [:title, :description, :prepTime, :cookingTime, :servingCount, :imageLink, :instructions, :uuid],
						include: {
							user: {
								only: [:username]
							},
							recipe_ingredients: {
								only: [:weight],
								include: {
									ingredient: {
										only: [:uuid]
									},
									recipe: {
										only: [:uuid]
									}
								}
							},
							user_ingredients: {
								only: [:weight],
								include: {
									ingredient: {
										only: [:uuid]
									}
								}
							}
						}
					}
				]
			)}, status: :accepted
			# render json: { user: UserSerializer.new(@user), token: @token }, status: :created
		else
			render json: { error: 'failed to create user' }, status: :not_acceptable
		end
	end

	def all_recipes
		user = User.find_by(username: params[:username])

		if user
			render json: user.to_json(
				only: [:username],
				include: [recipes: {
					only: [:title, :description, :prepTime, :cookingTime, :servingCount, :imageLink, :instructions, :uuid],
					include: {
						user: {
							only: [:username]
						},
						recipe_ingredients: {
							only: [:weight],
							include: {
								ingredient: {
									only: [:uuid]
								},
								recipe: {
									only: [:uuid]
								}
							}
						},
						user_ingredients: {
							only: [:weight],
							include: {
								ingredient: {
									only: [:uuid]
								}
							}
						}
					}
				}]
				), status: :accepted
		else
			render json: { error: 'failed to find user' }, status: :not_acceptable
		end
	end

	def update_ingredients
		user_params[:ingredients].each do |ingredient|
			ing = Ingredient.find_by(uuid: ingredient[:uuid])
			if ing
				ui = UserIngredient.find_by(user: @user, ingredient: ing)
				if ui
					if ingredient[:weight] != 0
						ui.update(weight: ingredient[:weight])
					else
						ui.destroy
					end
				else
					UserIngredient.create(user: @user, ingredient: ing, weight: ingredient[:weight])
				end
			end
		end
		render json: @user.to_json(
			only: [:username],
			include: [
				user_ingredients: {
					only: [:weight],
					include: {
						ingredient: {
							only: [:uuid]
						}
					}
				}
			]
		), status: :accepted
	end

	def remove_ingredients
		user_params[:ingredients].each do |ingredient|
			ing = Ingredient.find_by(uuid: ingredient[:uuid])
			if ing
				ui = UserIngredient.find_by(user: @user, ingredient: ing)
				if ui
					ui.destroy
				end
			end
		end
		render json: @user.to_json(
			only: [:username],
			include: [
				user_ingredients: {
					only: [:weight],
					include: {
						ingredient: {
							only: [:uuid]
						}
					}
				}
			]
		), status: :accepted
	end

	private

	def user_params
		params.require(:user).permit(:username, :password, :bio, :avatar, :ingredients => [:uuid, :weight])
	end

end