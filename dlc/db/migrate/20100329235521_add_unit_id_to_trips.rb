class AddUnitIdToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :unit_id, :integer
  end

  def self.down
    remove_column :trips, :unit_id
  end
end
