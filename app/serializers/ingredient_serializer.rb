class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :name, :category, :index
end
