class Tag < ActiveRecord::Base
  attr_accessible :text
  belongs_to :image
end
