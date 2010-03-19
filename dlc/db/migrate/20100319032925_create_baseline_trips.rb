class CreateBaselineTrips < ActiveRecord::Migration
  def self.up
    create_table :baseline_trips do |t|
      t.integer :baseline_id
      t.integer :destination_id
      t.integer :unit_id
      t.decimal :alone
      t.decimal :green
      t.timestamps
    end
  end
  
  def self.down
    drop_table :baseline_trips
  end
end
