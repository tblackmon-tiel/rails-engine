class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
      render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def destroy
    render json: Item.destroy(params[:id]), status: :no_content
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)

    render json: ItemSerializer.new(item)

    # if item.update(item_params)
    #   render json: ItemSerializer.new(item)
    # else
    #   render json: {}, status: 400
    # end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def not_found_response(error)
      render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404)).serialize_json, status: 404
    end

    def invalid_response(error)
      render json: ErrorSerializer.new(ErrorMessage.new(error.message, 400)).serialize_json, status: 400
    end
  end