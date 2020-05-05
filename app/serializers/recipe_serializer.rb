class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :title, :imageLink, :prepTime, :cookingTime, :description
  has_one :user
end
