class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :title, :imageLink, :prepTime, :cookingTime, :description, :ingredients
	has_one :user
end