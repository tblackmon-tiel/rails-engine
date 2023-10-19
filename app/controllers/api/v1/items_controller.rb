class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    begin
      render json: ItemSerializer.new(Item.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404)).serialize_json, status: 404
    end
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def destroy
    render json: Item.destroy(params[:id]), status: :no_content
  end

  def update
    item = Item.find(params[:id])    
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: {}, status: 400
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end