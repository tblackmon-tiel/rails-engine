class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.by_merchant(params[:merchant_id]))
  end
end