class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    @bulk_discounts = @merchant.bulk_discounts
  end
end