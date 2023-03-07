class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  
  validates :percentage_discount, presence: true
  validates :quantity_threshold, presence: true
end