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
    bulk_discounts = self.bulk_discounts.order(:quantity_threshold) #Lowest quantity threshold first to be overwritten with higher quantity thresholds later
    if bulk_discounts.length > 0 #Ensure merchant has discounts
      bulk_discounts.map do |discount| #Run through discounts, lowest q_threshold first
        invoice_items.where('invoice_items.quantity >= ?', discount.quantity_threshold) #Only access items with a quantity above threshold
                     .group(:id)
                     .each do |invoice_item_with_discount| #apply the discount to only the item that meets requirements
          invoice_item_with_discount.discounted_item_price(discount.percent_discount) #pass the percent discount price in
        end
      end
      total_revenue # Add all updated item prices together
    else
      total_revenue
    end
  end
end
