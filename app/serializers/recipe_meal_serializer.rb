class RecipeMealSerializer < ActiveModel::Serializer
  attributes :id, :planned_date
  has_one :recipe
  has_one :user
end
