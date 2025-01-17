class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item
  
  enum status: ["packaged", "pending", "shipped"]

  def best_discount
    bulk_discounts
    .where("quantity_threshold <= ?", quantity)
    .order(percentage_discount: :desc)
    .first
    #? is taking the quantity of the invoice item and comparing it to the bulk discount threshold
  end
end
