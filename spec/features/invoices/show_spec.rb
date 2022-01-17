require 'rails_helper'

RSpec.describe "Merchant invoice show" do
  it 'shows all the information relation to the invoice' do
    visit merchant_invoice_path(@merchant_1, @invoice_1)

    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_1.status)
    expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y") )
    expect(page).to have_content(@invoice_1.customer.first_name)
    expect(page).to have_content(@invoice_1.customer.last_name)
  end

  it 'shows all items and information' do
    visit merchant_invoice_path(@merchant_1, @invoice_1)

    @invoice_1.invoice_items.each do |invoice_item|
      expect(page).to have_content(invoice_item.item.name)
      expect(page).to have_content(invoice_item.quantity)
      expect(page).to have_content("Price: #{h.number_to_currency(invoice_item.unit_price/100, precision: 0)}")
      expect(page).to have_content(invoice_item.status)
    end
  end

  it 'does not show other merchants items info' do
    other_merchant = Merchant.create!(name: "Other Merchant")
    other_merchant_item = other_merchant.items.create!(name: "Other Merchant Item", description: "Description of other merchants item", unit_price: 33)

    visit merchant_invoice_path(@merchant_1, @invoice_1)

    expect(page).to_not have_content("#{other_merchant_item.name}")
  end

  it 'has a select field to update the invoice_item status' do
    visit merchant_invoice_path(@merchant_1, @invoice_1)

    @invoice_1.invoice_items.each do |invoice_item|
      expect(page).to have_content("pending")
      select "packaged", from: "invoice_item_status"
      click_on "Update Item Status"

      expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))
      expect(page).to have_content("#{invoice_item.status}")
    end
  end

  it 'I see the total revenue that will be generated from all of my items on the invoice' do
    visit merchant_invoice_path(@merchant_1, @invoice_4)

    expect(page).to have_content("Total Revenue")
    expect(page).to have_content(h.number_to_currency(@invoice_4.total_revenue/100, precision: 0))
  end

  it 'I see the total discounted revenue for my merchant from this invoice which includes bulk discounts' do
    visit merchant_invoice_path(@merchant_1, @invoice_4)

    expect(page).to have_content("Total Revenue")
    expect(page).to have_content(h.number_to_currency(@invoice_4.total_revenue/100, precision: 0))

    expect(page).to have_content("Total Discounted Revenue")
    expect(page).to have_content(h.number_to_currency(@invoice_4.total_discounted_revenue/100, precision: 0))
  end

  it 'ensures that the best discount is being used' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    expect(page).to have_content("Total Discounted Revenue: $4,368") #30% off 20+ items
    expect(page).to_not have_content("Total Discounted Revenue: $4,992") #20% off 10+ items
  end

  it 'ensures that the best discount is being used' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 30, unit_price: @item_4.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    expect(page).to have_content("Total Discounted Revenue: $5,616") #40% off 30+ items
  end

  it 'no discounts are applied if no items meet the quantity threshold' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 9, unit_price: @item_4.unit_price, status: 0)
    invoice_21.invoice_items.create!(item_id: @item_5.id, quantity: 3, unit_price: @item_5.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    expect(page).to have_content("Total Revenue: $2,877")
    expect(page).to have_content("Total Discounted Revenue: $2,877")
  end

  it 'is only applied to the items that meet the quantity threshold' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)
    invoice_21.invoice_items.create!(item_id: @item_5.id, quantity: 3, unit_price: @item_5.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    expect(page).to have_content("Total Revenue: $6,309")
    #20 * 312 = 6240 * .7 (with 30% off 20 or more items) = 4368 + (3 * 23 = 69) = 4437
    expect(page).to have_content("Total Discounted Revenue: $4,437")
  end

  it 'applies the discounts to the individual items that meet their own quantity thresholds' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)
    invoice_21.invoice_items.create!(item_id: @item_5.id, quantity: 10, unit_price: @item_5.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    expect(page).to have_content("Total Revenue: $6,470")
    #20 * 312 = 6240 * .7 (with 30% off 20 or more items) = 4368
    #10 * 23 = 230 * .8 (with 20% off 10 or more items) = 184
    #4368 + 184 = 4552
    expect(page).to have_content("Total Discounted Revenue: $4,552")
  end

  it 'displays a link next to each item to the show page of the bulk discount applied to it' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 30, unit_price: @item_4.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    ii = invoice_21.invoice_items.first
    within("#invoice_item-#{ii.id}") do
      click_link "Discount #:#{ii.find_discount_used.id}"
    end

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_3.id}")
  end

  it 'show page link will change depending on the quantity threshold' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    ii = invoice_21.invoice_items.first
    within("#invoice_item-#{ii.id}") do
      click_link "Discount #:#{ii.find_discount_used.id}"
    end

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_2.id}")
  end

  it 'show page link will change depending on the quantity threshold' do
    invoice_21 = @customer_6.invoices.create!
    invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 10, unit_price: @item_4.unit_price, status: 0)

    visit merchant_invoice_path(@merchant_1, invoice_21)

    ii = invoice_21.invoice_items.first
    within("#invoice_item-#{ii.id}") do
      click_link "Discount #:#{ii.find_discount_used.id}"
    end

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}")
  end
end
