class SearchController < ApplicationController

	skip_before_action :authorized, only: [:search]

	def search
		recipes = Recipe.search(params[:query])
		render json: recipes, status: :accepted
	end
end