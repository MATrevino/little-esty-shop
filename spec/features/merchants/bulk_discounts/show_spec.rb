require 'rails_helper'

RSpec.describe 'merchant bulk discount show page', type: :feature do
  describe 'as a merchant visiting their bulk discount show page' do
    let!(:merchant1) { create(:merchant)}
    let!(:merchant2) { create(:merchant)}

    let!(:bulkdiscount1) {BulkDiscount.create!(merchant: merchant1, name: "20% of 5", percentage_discount: 0.20, quantity_threshold: 5)}
    let!(:bulkdiscount2) {BulkDiscount.create!(merchant: merchant1, name: "30% of 10", percentage_discount: 0.30, quantity_threshold: 10)}
    let!(:bulkdiscount3) {BulkDiscount.create!(merchant: merchant2, name: "10% of 15", percentage_discount: 0.10, quantity_threshold: 15)}
    before do
      visit "/merchants/#{merchant1.id}/bulk_discounts/#{bulkdiscount1.id}"
    end
    it 'I see the bulk discounts quantity threshold and percentage discount' do

      expect(page).to have_content("Name of discount: #{bulkdiscount1.name}")
      expect(page).to have_content("Percentage off: 20.0%") 
      expect(page).to have_content("Quantity Threshold: #{bulkdiscount1.quantity_threshold}")
      expect(page).to_not have_content("Name of discount: #{bulkdiscount2.name}")
    
    end

    it 'shows a link to edit the bulk discount' do
      expect(page).to have_link("Edit Discount")
    end

    describe "when I click link, taken to a form to edit discount with form prepopulated with current info" do
      it 'when I change any/all info and click submit, I am redirected to bulk discount show page and see updates' do
        click_link "Edit Discount"
        
        expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulkdiscount1.id}/edit")
      
        expect(page).to have_field(:name, with: bulkdiscount1.name)
        expect(page).to have_field(:percentage_discount, with: bulkdiscount1.percentage_discount)
        expect(page).to have_field(:quantity_threshold, with: bulkdiscount1.quantity_threshold)
        expect(page).to have_button("Update Discount")

        fill_in :name, with: "Big Deal"
        fill_in :percentage_discount, with: 0.5
        fill_in :quantity_threshold, with: 100

        click_on "Update Discount"

        expect(page).to have_content("Big Deal")
        expect(page).to have_content("50.0%")
        expect(page).to have_content(100)

        expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulkdiscount1.id}")
      end
    end
  end
end