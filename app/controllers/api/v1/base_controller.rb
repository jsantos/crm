class Api::V1::BaseController < ApplicationController
  rescue_from Exception, with: :generic_exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def generic_exception(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")
    render json: { error: error.message }, status: :internal_server_error
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
