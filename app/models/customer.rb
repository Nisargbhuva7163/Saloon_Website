class Customer < ApplicationRecord
  has_many :customer_combos, dependent: :destroy
  has_many :combos, through: :customer_combos


  def self.ransackable_attributes(_auth_object = nil)
    [ "name", "email", "phone_number" ]
  end
end
