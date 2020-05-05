Rails.application.routes.draw do
  resources :user_ingredients
  resources :recipe_ingredients
  resources :ingredients
  resources :recipe_stars
  resources :recipes
	namespace :api do
		namespace :v1 do
			resources :users, only: [:create]
			post '/login', to: 'auth#create'
			get '/profile', to: 'users#profile'
		end
	end
end