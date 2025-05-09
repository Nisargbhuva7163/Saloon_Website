class Customer < ApplicationRecord
  has_many :customer_combos, dependent: :destroy
  has_many :combos, through: :customer_combos

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }
  validates :phone_number, presence: true, length: { is: 10 }, numericality: { only_integer: true }



  def self.ransackable_attributes(_auth_object = nil)
    [ "name", "email", "phone_number" ]
  end
end
