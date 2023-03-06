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

    describe "next to each bulk discount I see a link to delete it" do
      it 'when I click link, it redirects back to bulk discount index page and no longer shows that discount' do
        visit "/merchants/#{merchant1.id}/bulk_discounts"

        expect(page).to have_button("Delete #{bulkdiscount1.name} Discount")

        click_button "Delete #{bulkdiscount1.name} Discount"

        expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts")
        expect(page).to_not have_content(bulkdiscount1.name)
        expect(page).to_not have_content(bulkdiscount1.percentage_discount)
      end
    end
    
    describe 'Holiday API' do
      it "I see a header (Upcoming Holidays), in this section, the name and date of the next 3 upcoming US holidays" do
        visit "/merchants/#{merchant1.id}/bulk_discounts"
        expect(page).to have_content("Upcoming Holidays")

        expect(page).to have_content("Good Friday")
        expect(page).to have_content("2023-04-07")

        expect(page).to have_content("Memorial Day")
        expect(page).to have_content("2023-05-29")

        expect(page).to have_content("Juneteenth")
        expect(page).to have_content("2023-06-19")
      end
    end
  end
end