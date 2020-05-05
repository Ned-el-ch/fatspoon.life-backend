Rails.application.routes.draw do
	namespace :api do
		namespace :v1 do
			resources :users, only: [:create]
			post '/login', to: 'auth#create'
			get '/profile', to: 'users#profile'
			get '/chefs/:username', to: 'users#all_recipes'
		end
	end

	post '/recipes/new', to: 'recipes#create'
end