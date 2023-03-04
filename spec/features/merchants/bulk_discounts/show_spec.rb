require 'rails_helper'

RSpec.describe 'merchant bulk discount show page', type: :feature do
  describe 'as a merchant visiting their bulk discount show page' do
    let!(:merchant1) { create(:merchant)}
    let!(:merchant2) { create(:merchant)}

    let!(:bulkdiscount1) {BulkDiscount.create!(merchant: merchant1, name: "20% of 5", percentage_discount: 0.20, quantity_threshold: 5)}
    let!(:bulkdiscount2) {BulkDiscount.create!(merchant: merchant1, name: "30% of 10", percentage_discount: 0.30, quantity_threshold: 10)}
    let!(:bulkdiscount3) {BulkDiscount.create!(merchant: merchant2, name: "10% of 15", percentage_discount: 0.10, quantity_threshold: 15)}

    it 'I see the bulk discounts quantity threshold and percentage discount' do
      visit "/merchants/#{merchant1.id}/bulk_discounts/#{bulkdiscount1.id}"

      expect(page).to have_content("Name of discount: #{bulkdiscount1.name}")
      expect(page).to have_content("Percentage off: 20.0%") 
      expect(page).to have_content("Quantity Threshold: #{bulkdiscount1.quantity_threshold}")
    end
  end
end