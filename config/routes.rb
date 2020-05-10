Rails.application.routes.draw do

	resources :recipe_meals
	namespace :api do
		namespace :v1 do
			resources :users, only: [:create]
			post '/login', to: 'auth#create'
			get '/profile', to: 'users#profile'
			get '/chefs/:username', to: 'users#all_recipes'
			post '/ingredients/update', to: 'users#update_ingredients'
			post '/ingredients/remove', to: 'users#remove_ingredients'
		end
	end
	
	get '/recipes/:uuid', to: 'recipes#show'
	post '/recipes/new', to: 'recipes#create'
	post '/recipes/star', to: 'recipes#star_recipe'
	post '/recipes/unstar', to: 'recipes#unstar_recipe'
	post '/meal_planner/add', to: 'recipes#add_recipe_to_meal_planner'
	post '/meal_planner/remove', to: 'recipes#remove_recipe_from_meal_planner'

end