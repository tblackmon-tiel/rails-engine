class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { errors: "Name and price parameters cannot be requested at the same time" }, status: 400
    elsif params[:min_price].to_f < 0 || params[:max_price].to_f < 0
      render json: { errors: "Min and max price must be a positive number" }, status: 400
    elsif params[:name].present?
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    elsif params[:min_price].present? && params[:max_price].present?
      render json: ItemSerializer.new(Item.find_all_by_price_range(params[:min_price], params[:max_price]))
    elsif params[:min_price].present?
      render json: ItemSerializer.new(Item.find_all_by_min_price(params[:min_price]))
    elsif params[:max_price].present?
      render json: ItemSerializer.new(Item.find_all_by_max_price(params[:max_price]))
    end
  end
end