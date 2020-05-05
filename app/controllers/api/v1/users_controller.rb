class Api::V1::UsersController < ApplicationController

	skip_before_action :authorized, only: [:create, :all_recipes]

	def profile
		render json: { user: UserSerializer.new(current_user) }, status: :accepted
	end

	def create
		@user = User.create(user_params)
		if @user.valid?
			@token = encode_token({ user_id: @user.id })
			render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
		else
			render json: { error: 'failed to create user' }, status: :not_acceptable
		end
	end

	def all_recipes
		user = User.find_by(username: params[:username])

		if user
			render json: user.to_json(
				include: [recipes: {
					only: [:title, :description, :prepTime, :cookingTime, :servingCount, :imageLink, :instructions, :uuid],
					include: {
						user: {
							only: [:username]
						},
						recipe_ingredients: {
							only: [:weight, :uuid],
							include: {ingredient: {
								only: [:uuid]
							}}
						}
					}
				}]
				), status: :accepted
		else
			render json: { error: 'failed to find user' }, status: :not_acceptable
		end
	end

	private

	def user_params
		params.require(:user).permit(:username, :password, :bio, :avatar)
	end

end