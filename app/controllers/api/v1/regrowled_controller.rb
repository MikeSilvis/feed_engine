class Api::V1::MetaDataController < Api::V1::BaseController
  before_filter :authenticate_user

  def create
    Growl.regrowled_new(params[:id], current_user.id)
    render location: @growl, status: :created
  end

  private

  def authenticate_user
    @current_user = User.find_by_authentication_token(params[:token])
    unless @current_user
      render :json => "Token is invalid.".to_json, status: 401
    end
  end

  def current_user
    @current_user
  end
end