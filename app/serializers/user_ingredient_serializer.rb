class UserIngredientSerializer < ActiveModel::Serializer
  attributes :id, :weight
  has_one :ingredient
  has_one :user
end
