class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.string :type, :null => false
      t.string :remote_id, :null => false
      t.string :title
      t.timestamps
    end
    add_index :images, [:type, :remote_id], :unique => true
  end

  def down
    drop_table :images
  end
end
