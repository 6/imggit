class ChangeImageTitleToText < ActiveRecord::Migration
  def change
    change_column :images, :title, :text
  end

  def down
    change_column :images, :title, :string
  end
end
