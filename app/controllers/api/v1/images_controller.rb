class Api::V1::ImagesController < Api::V1::ApiController
  #before_filter :authenticate_user!
  respond_to :json

  def index
    @images = Image.all
    respond_with(@images)
  end

end