require 'rails_helper'

RSpec.describe 'Bulk Discounts New Page' do
  describe 'view' do
    it 'shows the user that they are on the Create A New Discount page' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      expect(page).to have_content("Create A New Discount")
    end

    it 'fills out and submits the new discount form' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in('Percent Discount', with: 10)
      fill_in('Quantity Threshold', with: 5)
      click_button('Submit')

      new_discount = BulkDiscount.last
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("Discount #: #{new_discount.id} (#{new_discount.percent_discount}% off #{new_discount.quantity_threshold} or more items)")
    end

    it 'sad path: gives error messages when form is submitted with empty fields' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      expect(page).to_not have_content("Discount not created: Fields can't be blank")

      click_button('Submit')

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("4 errors prohibited this post from being saved")
      expect(page).to have_content("Percent discount can't be blank")
      expect(page).to have_content("Percent discount must be between 0 and 100")
      expect(page).to have_content("Quantity threshold can't be blank")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end

    it 'sad path: gives arror message when percent discount is outside of range' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in('Percent Discount', with: 101)
      fill_in('Quantity Threshold', with: 5)

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Percent discount must be between 0 and 100")
    end

    it 'sad path: gives arror message when quantitythreshold is outside of range' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in('Percent Discount', with: 45)
      fill_in('Quantity Threshold', with: 1)

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end

    it 'sad path: user attempts to fill in Quantity Threshold field with other characters' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in('Percent Discount', with: 45)
      fill_in('Quantity Threshold', with: "rs")

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end

    it 'sad path: user attempts to fill in Percent Discount field with other characters' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in('Percent Discount', with: "dfse")
      fill_in('Quantity Threshold', with: 2)

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("1 error prohibited this post from being saved")
      expect(page).to have_content("Percent discount must be between 0 and 100")
    end

    it 'sad path: user attempts to leave a field blank and fill in Percent Discount field with other characters' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"

      fill_in('Percent Discount', with: "dfse")

      click_button('Submit')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("3 errors prohibited this post from being saved")
      expect(page).to have_content("Percent discount must be between 0 and 100")
      expect(page).to have_content("Quantity threshold can't be blank")
      expect(page).to have_content("Quantity threshold must be 2 or greater.")
    end
  end
end
