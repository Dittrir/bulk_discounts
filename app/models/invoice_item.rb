class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  validates :quantity, :unit_price, :status, presence: true
  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def discounted_item_price(discounted_percent)
    item_price = self.item.unit_price
    percent_of_total_price = ((100 - discounted_percent).to_f * 0.01).round(3)
    InvoiceItem.where(item_id: self.item_id).each do |ii|
      ii.update_column(:unit_price, (item_price * percent_of_total_price))
    end
  end

  def discount_used
    binding.pry
  end
end
