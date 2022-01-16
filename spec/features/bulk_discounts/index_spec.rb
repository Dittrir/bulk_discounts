require 'rails_helper'

RSpec.describe 'Bulk Discount Index Page' do
  describe 'view' do
    before(:each) do
      @discount_1 = @merchant_1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 10)
      @discount_2 = @merchant_1.bulk_discounts.create!(percent_discount: 30, quantity_threshold: 20)
      @discount_3 = @merchant_1.bulk_discounts.create!(percent_discount: 40, quantity_threshold: 30)
    end

    it 'displays Discounts at the top' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      expect(page).to have_content("Discounts")
    end

    it 'displays all discount info and links to show page' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      expect(page).to have_content("Discount #: #{@discount_1.id} (#{@discount_1.percent_discount}% off #{@discount_1.quantity_threshold} or more items)")
      expect(page).to have_content("Discount #: #{@discount_2.id} (#{@discount_2.percent_discount}% off #{@discount_2.quantity_threshold} or more items)")
      expect(page).to have_content("Discount #: #{@discount_3.id} (#{@discount_3.percent_discount}% off #{@discount_3.quantity_threshold} or more items)")

      within("#discount-#{@discount_1.id}") do
        click_link "Check it out here!"

        expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}")
      end
    end

    it 'has a link to create a new discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      click_link "Create A New Discount"
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/new")
    end

    it 'next to each bulk discount index I see a link to delete it' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      expect(page).to have_content("Discount #: #{@discount_1.id} (#{@discount_1.percent_discount}% off #{@discount_1.quantity_threshold} or more items)")

      within("#discount-#{@discount_1.id}") do
        click_link "Delete this discount"
      end

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to_not have_content("Discount #: #{@discount_1.id} (#{@discount_1.percent_discount}% off #{@discount_1.quantity_threshold} or more items)")
    end
  end
end
