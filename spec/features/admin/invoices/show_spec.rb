require 'rails_helper'

RSpec.describe 'Admin Invoices Show' do
  describe 'view' do

    it 'I see information related to that invoice' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
      expect(page).to have_content(@invoice_1.customer.first_name)
      expect(page).to have_content(@invoice_1.customer.last_name)
    end

    it 'I see the total revenue that will be generated from this invoice' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("Total Revenue Generated: $16")
    end

    it 'I can update the invoice status' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("pending")
      select "in progress", from: "invoice_status"
      click_on "Update Invoice Status"

      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content("#{@invoice_1.status}")
    end

    it 'displays all of the items and their attributes' do
      visit "/admin/invoices/#{@invoice_1.id}"

      ii = @invoice_1.invoice_items.first

      within "#invoice_show-#{@invoice_1.id}" do
        expect(page).to have_content("Item Name: Item_1")
        expect(page).to have_content("Item Quantity: 1")
        expect(page).to have_content("Item Unit Price: $16")
        expect(page).to have_content("Item Status: pending")
      end
    end

    it 'displays all of the items and their attributes' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("Total Discounted Revenue: $16")
    end
  end
end
