class Api::V1::AuthController < ApplicationController

	skip_before_action :authorized, only: [:create]

	def create
		@user = User.find_by(username: user_login_params[:username])
		#User#authenticate comes from BCrypt
		if @user && @user.authenticate(user_login_params[:password])
			# encode token comes from ApplicationController
			token = encode_token({ user_id: @user.id })
			render json: {
				token: token,
				user_data: @user.to_json(
				only: [:username],
				include: {
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
					},
					recipe_stars: {
						only: [],
						include: {
							recipe: {
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
							}
						}
					},
					recipe_meals: {
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
											user: {
												only: [:username]
											}
										}
									}
								}
							}
						}
					}
				}
			)}, status: :accepted
			# render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
		else
			render json: { message: 'Invalid username or password' }, status: :unauthorized
		end
	end

	private

	def user_login_params
		# params { user: {username: 'Chandler Bing', password: 'hi' } }
		params.require(:user).permit(:username, :password)
	end

end