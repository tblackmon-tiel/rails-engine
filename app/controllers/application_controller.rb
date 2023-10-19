class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def not_found_response(error)
    ser = ErrorSerializer.new(ErrorMessage.new(error.message, 404))
    render json: ser.serialize_json, status: 404
  end
end
