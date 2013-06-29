class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.integer :image_id, :null => false
      t.string :text, :null => false
      t.timestamps
    end
  end

  def down
    drop_table :tags
  end
end
