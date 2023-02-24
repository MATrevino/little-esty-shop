require 'rails_helper'

RSpec.describe 'merchant show dashboard page', type: :feature do
  describe "as a merchant visiting '/merchants/merchant_id/dashboard'" do
    let!(:merchant1) {Merchant.create!(name: "Brian's Beads")}

    let!(:customer1) { Customer.create!(first_name: "Britney", last_name: "Spears")}
    let!(:customer2) { Customer.create!(first_name: "Bob", last_name: "Smith")}
    let!(:customer3) { Customer.create!(first_name: "Bill", last_name: "Johnson")}
    let!(:customer4) { Customer.create!(first_name: "Boris", last_name: "Nelson")}
    let!(:customer5) { Customer.create!(first_name: "Barbara", last_name: "Hilton")}
    let!(:customer6) { Customer.create!(first_name: "Bella", last_name: "Thomas")}

    let!(:invoice1) { customer1.invoices.create!(status: 2) }
    let!(:invoice2) { customer1.invoices.create!(status: 2) }
    let!(:invoice3) { customer2.invoices.create!(status: 2) }
    let!(:invoice4) { customer2.invoices.create!(status: 2) }
    let!(:invoice5) { customer3.invoices.create!(status: 2) }
    let!(:invoice6) { customer3.invoices.create!(status: 2) }
    let!(:invoice7) { customer4.invoices.create!(status: 2) }
    let!(:invoice8) { customer5.invoices.create!(status: 2) }
    let!(:invoice9) { customer5.invoices.create!(status: 2) }
    let!(:invoice10) { customer6.invoices.create!(status: 2) }
    let!(:invoice11) { customer6.invoices.create!(status: 2) }

    let!(:item1) { merchant1.items.create!(name: "water bottle", description: "24oz metal container for water", unit_price: 8) }    
    let!(:item2) { merchant1.items.create!(name: "rubber duck", description: "toy for bath", unit_price: 1) }    
    let!(:item3) { merchant1.items.create!(name: "lamp", description: "12 inch desk lamp", unit_price: 16) }    
    let!(:item4) { merchant1.items.create!(name: "wireless mouse", description: "wireless computer mouse for mac", unit_price: 40) }    
    let!(:item5) { merchant1.items.create!(name: "chapstick", description: "coconut flavor chapstick", unit_price: 2) }    

    let!(:transaction1) {invoice1.transactions.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    let!(:transaction2) {invoice2.transactions.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    
    let!(:transaction3) {invoice3.transactions.create!(credit_card_number: 4140149827486249, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    let!(:transaction4) {invoice4.transactions.create!(credit_card_number: 4140149827486249, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
   
    let!(:transaction5) {invoice5.transactions.create!(credit_card_number: 4763141973880496, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    let!(:transaction6) {invoice6.transactions.create!(credit_card_number: 4763141973880496, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
   
    let!(:transaction14) {invoice7.transactions.create!(credit_card_number: 4504301557459341, credit_card_expiration_date: Date.new(2024, 1, 3), result: "failed") }
    let!(:transaction15) {invoice7.transactions.create!(credit_card_number: 4504301557459341, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    
    let!(:transaction7) {invoice8.transactions.create!(credit_card_number: 4173081602435789, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    let!(:transaction8) {invoice9.transactions.create!(credit_card_number: 4173081602435789, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    
    let!(:transaction9) {invoice10.transactions.create!(credit_card_number: 4972246905754900, credit_card_expiration_date: Date.new(2024, 1, 3), result: "failed") }
    let!(:transaction10) {invoice10.transactions.create!(credit_card_number: 4972246905754900, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    let!(:transaction11) {invoice11.transactions.create!(credit_card_number: 4972246905754900, credit_card_expiration_date: Date.new(2024, 1, 3), result: "success") }
    
    
    before do
      InvoiceItem.create!(item: item1, invoice: invoice1)
      InvoiceItem.create!(item: item2, invoice: invoice1)
      InvoiceItem.create!(item: item1, invoice: invoice2)
      InvoiceItem.create!(item: item4, invoice: invoice2)
      InvoiceItem.create!(item: item4, invoice: invoice3)
      InvoiceItem.create!(item: item3, invoice: invoice3)
      InvoiceItem.create!(item: item1, invoice: invoice4)
      InvoiceItem.create!(item: item4, invoice: invoice4)
      InvoiceItem.create!(item: item1, invoice: invoice5)
      InvoiceItem.create!(item: item2, invoice: invoice5)
      InvoiceItem.create!(item: item2, invoice: invoice6)
      InvoiceItem.create!(item: item3, invoice: invoice6)

      InvoiceItem.create!(item: item5, invoice: invoice7)

      InvoiceItem.create!(item: item1, invoice: invoice8)
      InvoiceItem.create!(item: item3, invoice: invoice8)
      InvoiceItem.create!(item: item2, invoice: invoice9)
      InvoiceItem.create!(item: item3, invoice: invoice9)
      InvoiceItem.create!(item: item3, invoice: invoice10)
      InvoiceItem.create!(item: item4, invoice: invoice10)
      InvoiceItem.create!(item: item1, invoice: invoice11)
      InvoiceItem.create!(item: item4, invoice: invoice11)
    end
    

    it 'shows my name(merchant)' do
      
      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_content("Brian's Beads")
    end

    it "will have a link that takes me to the 'merchants/merchant_id/items index page" do 

      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_link("Merchant Items")

      click_link("Merchant Items")

      expect(current_path).to eq("/merchants/#{merchant1.id}/items")
    end

    it "will have a link that takes me to the 'merchants/merchant_id/invoices index page" do 

      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_link("Merchant Invoices")

      click_link("Merchant Invoices")

      expect(current_path).to eq("/merchants/#{merchant1.id}/invoices")
    end 

    it 'shows the names of the top 5 customers(largest number of successful transactions with merchant) and the number of transactions conducted with merchant' do
      visit "/merchants/#{merchant1.id}/dashboard"

      expect(page).to have_content("Top 5 customers with largest transactions")
      expect(page).to have_content("Britney Spears- number of transactions: 2")
      expect(page).to have_content("Bob Smith- number of transactions: 2")
      expect(page).to have_content("Bill Johnson- number of transactions: 2")
      expect(page).to have_content("Barbara Hilton- number of transactions: 2")
      expect(page).to have_content("Bella Thomas- number of transactions: 2")
      expect(page).to_not have_content("Boris Nelson")
    end
  end
end