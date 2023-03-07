require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
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

  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:bulk_discounts).through(:item) }
    it { should define_enum_for(:status).with_values(["packaged", "pending", "shipped"])}
  end

  describe 'instance methods' do
    it 'best_discount' do
      expect(@invoice_item1.best_discount).to eq(bulkdiscount2)
      expect(@invoice_item2.best_discount).to eq(nil)
      expect(@invoice_item3.best_discount).to eq(bulkdiscount1)
      expect(@invoice_item4.best_discount).to eq(nil)
    end
  end
end
