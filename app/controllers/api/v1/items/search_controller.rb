class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name]
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    elsif params[:min_price] && params[:max_price]
      render json: ItemSerializer.new(Item.find_all_by_price_range)
    elsif params[:min_price]
      render json: ItemSerializer.new(Item.find_all_by_min_price)
    elsif params[:max_price]
      render json: ItemSerializer.new(Item.find_all_by_max_price)
    end
  end
end