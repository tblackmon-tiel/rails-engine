class Api::V1::Items::SearchController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
  end
end