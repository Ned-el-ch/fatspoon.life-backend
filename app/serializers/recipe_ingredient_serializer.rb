class RecipeIngredientSerializer < ActiveModel::Serializer
  attributes :id, :weight
  has_one :ingredient
  has_one :recipe
end
