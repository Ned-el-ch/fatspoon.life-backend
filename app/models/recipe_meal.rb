class RecipeMeal < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
end
