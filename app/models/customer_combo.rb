class CustomerCombo < ApplicationRecord
  belongs_to :customer
  belongs_to :combo
  has_many :redeems
end
