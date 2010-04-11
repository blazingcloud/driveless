class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.integer :user_id
      t.integer :destination_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :trips
  end
end
