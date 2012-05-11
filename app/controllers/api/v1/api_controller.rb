class Api::V1::ApiController < ActionController::Base

  def validation_error(obj)
    render status: 406, json: obj.erors.full_messages
  end

  def success(code=201)
    render status: code, json: true
  end

end