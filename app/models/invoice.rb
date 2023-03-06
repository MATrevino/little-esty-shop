class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  
  enum status: ["cancelled", "in progress", "completed"]

  def self.invoice_items_not_shipped
    joins(:invoice_items).where.not(invoice_items: {status: 2}).distinct.order(:created_at)
  end

  def total_revenue
    self.invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def total_invoice_discount
    #gives the amount discounted ^ 
    binding.pry
    invoice_items.joins(item: {merchant: :bulk_discounts})
    .where("bulk_discounts.quantity_threshold <= invoice_items.quantity")
    .group("invoice_items.id")
    .select("MAX(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage_discount) as discount_amount")

  end

  def total_revenue_with_discount
    total_revenue - total_invoice_discount
  end 
end
