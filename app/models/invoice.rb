class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchant, through: :items
  has_many :bulk_discounts, through: :merchant
  validates :status, presence: true
  enum status: { cancelled: 0, "in progress" => 1, completed: 2, pending: 3 }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: "shipped"})
    .order(created_at: :asc)
    .distinct
  end

  def total_discounted_revenue
    best_discount = []
    items_with_discounts_applied = []
    bulk_discounts = self.bulk_discounts.order(:quantity_threshold)
    if bulk_discounts.length > 0
      bulk_discounts.map do |discount|
        invoice_items.where('invoice_items.quantity >= ?', discount.quantity_threshold)
                     .group(:id)
                     .each do |invoice_item_with_discount|
          best_discount << invoice_item_with_discount.discounted_item_price(discount.percent_discount)
        end
      end
      items_with_discounts_applied << best_discount.min
      (items_with_discounts_applied.sum).to_i
    else
      total_revenue
    end
  end
end
