class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(discount_params)
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(discount_params)
      if @bulk_discount.valid?
        @bulk_discount.save

        redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
      else
        render :new
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    merchant.bulk_discounts.destroy(bulk_discount)

    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  private
  def discount_params
    params.permit(:percent_discount, :quantity_threshold)
  end
end
