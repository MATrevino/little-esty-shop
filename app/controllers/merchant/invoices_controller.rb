class  Merchant::InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = @merchant.invoices.find(params[:id])
    @items_on_invoice = @invoice.items
    @total_discounted_revenue = @invoice.total_revenue_with_discount
  end
end