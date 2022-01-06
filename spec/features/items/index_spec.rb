require 'rails_helper'

RSpec.describe "Merchant item index" do
  it 'I see a list of the names of all of my items' do
    visit "/merchants/#{@merchant_1.id}/items"

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)
  end

  it 'each items name is a link to the show page' do
    visit "/merchants/#{@merchant_1.id}/items"

    click_link "#{@item_1.name}"
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_1.id}")
  end

  # it 'displays two sections, one for Enabled Items and one for Disabled Items' do
  #   visit "/merchants/#{@merchant_1.id}/items"
  #
  #   expect(page).to have_content("Enabled Items")
  #   expect(page).to have_content("Disabled Items")
  # end

  # it 'has enabled items in the enabled section and disable items in disabled section' do
  #   visit "/merchants/#{@merchant_1.id}/items"
  #
  #   within "Enabled Items" do
  # end

  it 'has a link to create a new item' do
    visit "/merchants/#{@merchant_1.id}/items"

    expect(page).to have_link("Create a New Item")
    click_link "Create a New Item"

  end
end
