class RecipeIngredientSerializer < ActiveModel::Serializer
	has_one :ingredient
	has_one :recipe
	attributes :id, :weight
end