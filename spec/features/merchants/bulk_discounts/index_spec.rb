require 'rails_helper'

RSpec.describe 'merchant bulk discount index page', type: :feature do
  describe 'as a merchant visiting their bulk discount index page' do
    let!(:merchant1) { create(:merchant)}
    let!(:merchant2) { create(:merchant)}

    let!(:bulkdiscount1) {BulkDiscount.create!(merchant: merchant1, name: "20% of 5", percentage_discount: 0.20, quantity_threshold: 5)}
    let!(:bulkdiscount2) {BulkDiscount.create!(merchant: merchant1, name: "30% of 10", percentage_discount: 0.30, quantity_threshold: 10)}
    let!(:bulkdiscount3) {BulkDiscount.create!(merchant: merchant2, name: "10% of 15", percentage_discount: 0.10, quantity_threshold: 15)}

    it 'has a link to create a new discount' do
      visit "/merchants/#{merchant1.id}/bulk_discounts"
      expect(page).to have_link("Create New Discount")
    end

    describe 'when I click the link, it takes me to a new page where I see a form to add a new bulk discount' do
      it 'fills out the form with valid data, and redirects back to bulk discount index and see the new discount' do
        visit "/merchants/#{merchant1.id}/bulk_discounts"

        click_link "Create New Discount"
        expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/new")

        fill_in :name, with: "50% off 100"
        fill_in :percentage_discount, with: 0.5
        fill_in :quantity_threshold, with: 100

        click_button "Create New Discount"
        expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts")
        expect(page).to have_content("50% off 100")
      end
    end
  end
end