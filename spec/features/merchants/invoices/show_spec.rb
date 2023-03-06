require 'rails_helper'

describe 'As a merchant', type: :feature do
  let!(:merchant1) { create(:merchant)}

  let!(:item1) {create(:item, merchant: merchant1)}  
  let!(:item2) {create(:item, merchant: merchant1)}
  let!(:item3) {create(:item, merchant: merchant1)}
  let!(:item4) {create(:item, merchant: merchant1)}
  let!(:item5) {create(:item, merchant: merchant1)}

  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer)}

  let!(:invoice1) {create(:invoice, created_at: Date.new(2020, 1, 2), customer: customer1)}
  let!(:invoice2) {create(:invoice, created_at: Date.new(2019, 3, 9), customer: customer2)}

  let!(:bulkdiscount1) {BulkDiscount.create!(merchant: merchant1, name: "20% of 5", percentage_discount: 0.20, quantity_threshold: 5)}
  let!(:bulkdiscount2) {BulkDiscount.create!(merchant: merchant1, name: "30% of 10", percentage_discount: 0.30, quantity_threshold: 10)}

  before(:each) do
    @invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 10, unit_price: 1000, status: 1)
    @invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 4, unit_price: 800, status: 1)
    @invoice_item3 = create(:invoice_item, invoice: invoice1, item: item3, quantity: 5, unit_price: 500, status: 1)
    @invoice_item4 = create(:invoice_item, invoice: invoice1, item: item4, quantity: 2, unit_price: 200, status: 1)
    # @invoice_item5 = create(:invoice_item, invoice: invoice2, item: item5, quantity: 1, unit_price: 100, status: 1)
  end

  describe "When I visit my merchant's invoice show page" do
    it 'I see the invoice ID, status, and created_at date with formatting' do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Invoice ##{invoice1.id}")
      expect(page).to_not have_content(invoice2.id)
      expect(page).to have_content("Status: #{invoice1.status}")
      expect(page).to have_content("Created on: #{invoice1.created_at.strftime("%A, %B %d, %Y")}")
    end

    it "I see the customers first and last name" do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      within "#customers" do
        expect(page).to have_content(customer1.first_name)
        expect(page).to have_content(customer1.last_name)
      end
    end

    it "I see all of my items on the invoice including: item name, quantity of item ordered, the price sold for, the invoice item status" do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"
      expect(page).to have_content("Items on this invoice")
      expect(page).to have_content("Item Name")
      expect(page).to have_content("Quantity")
      expect(page).to have_content("Unit Price")
      expect(page).to have_content("Status")

      expect(page).to have_content(item1.name)
      expect(page).to have_content(@invoice_item1.quantity)
      expect(page).to have_content(@invoice_item1.unit_price.to_f/100)
      expect(page).to have_content(@invoice_item1.status)

      expect(page).to have_content(item2.name)
      expect(page).to have_content(@invoice_item2.quantity)
      expect(page).to have_content(@invoice_item2.unit_price.to_f/100)
      expect(page).to have_content(@invoice_item2.status)

      expect(page).to have_content(item3.name)
      expect(page).to have_content(@invoice_item3.quantity)
      expect(page).to have_content(@invoice_item3.unit_price.to_f/100)
      expect(page).to have_content(@invoice_item3.status)

      expect(page).to have_content(item4.name)
      expect(page).to have_content(@invoice_item4.quantity)
      expect(page).to have_content(@invoice_item4.unit_price.to_f/100)
      expect(page).to have_content(@invoice_item4.status)

      expect(page).to_not have_content(item5.name)
    end

    # it 'will have a list of all usernames of contributors' do 
    #   visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"
      
    #   expect(page).to have_content("Collaborators")
    #   expect(page).to have_content("Bphayes1200")
    #   expect(page).to have_content("MATrevino")
    #   expect(page).to have_content("hamouj")
    #   expect(page).to have_content("axeldelaguardia")
    # end 

    describe "shows each invoice item status is a select field, the invoice item's current status is selected" do
      it 'when click select field, then I can select a new status for the item, next to field is a button to update item status' do
        visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"
        
        expect(page).to have_content(@invoice_item1.status)
        expect(page).to have_button("Update Item Status")

        within "##{@invoice_item1.id}" do
          expect(@invoice_item1.status).to eq("pending")

          select "shipped", from: :status
          click_button 'Update Item Status'
          expect(page).to have_select(selected: "shipped")
          expect(page).to_not have_select(selected: "pending")
        end
        
        expect(current_path).to eq("/merchants/#{merchant1.id}/invoices/#{invoice1.id}")
      end
    end

    it 'shows the total revenue that will be generated from all items on the invoice' do
      total_revenue = (@invoice_item1.unit_price * @invoice_item1.quantity) + (@invoice_item3.unit_price * @invoice_item3.quantity) + (@invoice_item4.unit_price * @invoice_item4.quantity) + (@invoice_item2.unit_price * @invoice_item2.quantity)
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"
      
      
      within '#total_revenue' do
        expect(page).to have_content("$#{total_revenue.to_f/100}")
      end
    end

    it 'I see the total revenue for my merchant from this invoice(not including discounts)' do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Total Revenue: $161")
    end

    it 'I also see the total discounted revenue for my merchant from this invoice, including bulk discounts in the calculation' do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"
      expect(page).to have_content("Total Discounted Revenue: $126")
    end
  end
end