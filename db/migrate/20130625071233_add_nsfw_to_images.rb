class AddNsfwToImages < ActiveRecord::Migration
  def change
    add_column :images, :nsfw, :boolean, :default => false, :null => false
  end
end
