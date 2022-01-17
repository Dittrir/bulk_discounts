class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  validates :quantity, :unit_price, :status, presence: true
  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def discounted_item_price(discount_pct)
    item_price = self.item.unit_price
    discounted_pct = ((100 - discount_pct).to_f * 0.01).round(3)
    InvoiceItem.where(item_id: self.item_id)
               .each do |ii|
                 ii.update_column(:unit_price, (item_price * discounted_pct))
    end
  end
end
