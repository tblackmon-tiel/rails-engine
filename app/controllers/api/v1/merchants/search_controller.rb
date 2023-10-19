class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if Merchant.find_by_name(params[:name])
      render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]))
    else
      render json: { data: {} }
    end
  end
end