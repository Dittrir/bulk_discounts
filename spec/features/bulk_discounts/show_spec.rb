require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do
  describe 'view' do
    before(:each) do
      @discount_1 = @merchant_1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 10)
      @discount_2 = @merchant_1.bulk_discounts.create!(percent_discount: 30, quantity_threshold: 20)
      @discount_3 = @merchant_1.bulk_discounts.create!(percent_discount: 40, quantity_threshold: 30)
    end

    it 'displays the bulk discounts quantity threshold and percentage discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}"

      expect(page).to have_content("Discount #: #{@discount_1.id}")
      expect(page).to have_content("This discount takes #{@discount_1.percent_discount}% off purchases of #{@discount_1.quantity_threshold} or more items!")
    end
  end
end
