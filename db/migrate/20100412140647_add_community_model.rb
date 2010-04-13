class AddCommunityModel < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name, :null => false
      t.string :state, :null => false
      t.string :country, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
