class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    get_next_three_holidays = HolidaysService.get_upcoming_us_holidays.first(3)
    @holidays = get_next_three_holidays.map do |holiday|
      UsHoliday.new(holiday)
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    
    bulk_discount = merchant.bulk_discounts.find(params[:id])
    bulk_discount.destroy
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.find(params[:id])
    if bulk_discount.update(bulk_discount_params)
       redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"
    else 
      flash[:notice] = "Invalid Input"
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"
    end
  end

  private
  def bulk_discount_params
    params.permit(:name, :percentage_discount, :quantity_threshold)
  end
end