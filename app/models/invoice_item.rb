class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  validates :quantity, :unit_price, :status, presence: true
  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def discounted_item_price(discount_pct)
    total_revenue = self.unit_price * self.quantity
    discount_pct = ((100 - discount_pct).to_f * 0.01).round(3)
    discount_pct * total_revenue
  end
end
