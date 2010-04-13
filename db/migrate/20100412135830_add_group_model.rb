class AddGroupModel < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :null => false
      t.integer :user_id => false
      t.integer :destination_id => false
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
