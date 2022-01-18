class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  belongs_to :merchant

  validates :name, :description, :unit_price, presence: true
  enum item_status: { disabled: 0, enabled: 1}

  def top_item_best_day
    invoices.select("invoices.*, sum(quantity) as total_sales")
            .group(:id)
            .order(total_sales: :desc)
            .first.updated_at
  end
end
