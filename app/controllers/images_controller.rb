class ImagesController < ApplicationController
  respond_to :html, :json

  def index
    per_page = 10
    offset = (params[:page].andand.to_i - 1 || 0) * per_page
     respond_with(@images = ImgurImage.offset(offset).limit(per_page))
  end
end
