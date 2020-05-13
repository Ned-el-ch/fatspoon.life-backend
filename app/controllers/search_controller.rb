class SearchController < ApplicationController

	skip_before_action :authorized, only: [:search]

	def search
		@recipes = Recipe.multisearch(params[:query])
		render json: @recipes
	end
end