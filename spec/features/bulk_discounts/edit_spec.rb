require 'rails_helper'

RSpec.describe 'Bulk Discount Edit Page' do
  describe 'view' do
    before(:each) do
      @discount_1 = @merchant_1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 10)
    end

    it 'fills out and submits the edit discount form from the show page' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}"

      expect(page).to have_content("Discount #: #{@discount_1.id}")
      expect(page).to have_content("This discount takes 20% off purchases of 10 or more items!")

      click_link("Edit this discount")

      fill_in('Percent Discount', with: 10)
      fill_in('Quantity Threshold', with: 5)
      click_button('Submit')

      edited_discount = BulkDiscount.last
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}")
      expect(page).to have_content("Discount Updated")
      expect(page).to have_content("Discount #: #{edited_discount.id}")
      expect(page).to have_content("This discount takes 10% off purchases of 5 or more items!")
    end

    it 'sad path: gives error messages when form is submitted with empty fields' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      expect(page).to_not have_content("Discount not created: Fields can't be left blank")

      click_button('Submit')

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("4 errors prohibited this post from being saved")
      expect(page).to have_content("Percent discount can't be left blank.")
      expect(page).to have_content("Percent discount must be between 0 and 100")
      expect(page).to have_content("Quantity threshold can't be left blank")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end

    it 'sad path: gives arror message when percent discount is outside of range' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      fill_in('Percent Discount', with: 101)
      fill_in('Quantity Threshold', with: 5)

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Percent discount must be between 0 and 100")
    end

    it 'sad path: gives arror message when quantitythreshold is outside of range' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      fill_in('Percent Discount', with: 45)
      fill_in('Quantity Threshold', with: 1)

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end

    it 'sad path: user attempts to fill in Quantity Threshold field with other characters' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      fill_in('Percent Discount', with: 45)
      fill_in('Quantity Threshold', with: "rs")

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end

    it 'sad path: user attempts to fill in Percent Discount field with other characters' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      fill_in('Percent Discount', with: "dfse")
      fill_in('Quantity Threshold', with: 2)

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Percent discount must be between 0 and 100")
    end

    it 'sad path: user attempts to leave a field blank and fill in Percent Discount field with other characters' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      fill_in('Percent Discount', with: "dfse")

      click_button('Submit')

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("3 errors prohibited this post from being saved")
      expect(page).to have_content("Percent discount must be between 0 and 100")
      expect(page).to have_content("Quantity threshold can't be left blank")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end
  end
end
