class Image < ActiveRecord::Base
  validates_presence_of :remote_id
  validates_uniqueness_of :remote_id, :scope => [:type]
end
