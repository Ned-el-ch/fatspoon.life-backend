class SearchController < ApplicationController

	skip_before_action :authorized, only: [:search]

	def search
		@recipes = Recipe.search_by_term(params[:query])
		render json: @recipes
	end
end