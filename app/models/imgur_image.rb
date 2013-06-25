class ImgurImage < Image
  validates_length_of :remote_id, :minimum => 5

  def url(size = :original)
    ImgurUrl::Image.from_id(remote_id).url(size)
  end

  def remote_permalink
    @remote_permalink ||= ImgurUrl::Image.from_id(remote_id).permalink_url
  end
end
