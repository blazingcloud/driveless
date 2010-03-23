class AddDistanceToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :distance, :decimal
  end

  def self.down
    remove_column :trips, :distance
  end
end
