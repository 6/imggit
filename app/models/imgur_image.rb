class ImgurImage < Image
  validates_length_of :remote_id, :minimum => 5
end
