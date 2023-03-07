class Admin::InvoicesController < ApplicationController
  def index
    @all_invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @total_discounted_revenue = @invoice.total_revenue_with_discount
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(status: params[:invoice_status])

    redirect_to admin_invoice_path(invoice)
  end
end