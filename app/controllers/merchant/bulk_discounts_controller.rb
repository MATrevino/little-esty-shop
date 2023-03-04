class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:id])
    bulk_discount = merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  private
  def bulk_discount_params
    params.permit(:name, :percentage_discount, :quantity_threshold)
  end
end