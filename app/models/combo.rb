class Combo < ApplicationRecord
  belongs_to :service

  validates :quantity, numericality: { greater_than: 0 }
  validates :discount, numericality: { greater_than_or_equal_to: 0 }
  validates :calculate_total_price, numericality: { greater_than: 0 }

  def calculate_total_price
    base_total = service.price * quantity
    self.total_price = base_total - discount
  end
end
