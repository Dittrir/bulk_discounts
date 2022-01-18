require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_many(:transactions).through(:invoice) }
  end

  describe 'methods' do
    it '#find_discount_used' do
      invoice_21 = @customer_6.invoices.create!
      invoice_22 = @customer_5.invoices.create!
      invoice_23 = @customer_4.invoices.create!

      ii_1 = invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 10, unit_price: @item_4.unit_price, status: 0)
      ii_2 = invoice_22.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)
      ii_3 = invoice_23.invoice_items.create!(item_id: @item_4.id, quantity: 30, unit_price: @item_4.unit_price, status: 0)

      expect(ii_1.find_discount_used).to eq(@discount_1)
      expect(ii_2.find_discount_used).to eq(@discount_2)
      expect(ii_3.find_discount_used).to eq(@discount_3)
    end

    it '#find_discount_used' do
      invoice_21 = @customer_5.invoices.create!
      ii_1 = invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 3, unit_price: @item_4.unit_price, status: 0)

      expect(ii_1.uses_discount?).to eq(false)
    end
  end
end
