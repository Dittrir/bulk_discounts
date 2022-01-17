require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do
  describe 'view' do
    it 'displays the bulk discounts quantity threshold and percentage discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}"

      expect(page).to have_content("Discount #: #{@discount_1.id}")
      expect(page).to have_content("This discount takes #{@discount_1.percent_discount}% off purchases of #{@discount_1.quantity_threshold} or more items!")
    end

    it 'provides a link for the user to edit the bulk discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}"

      click_link("Edit this discount")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
    end
  end
end
