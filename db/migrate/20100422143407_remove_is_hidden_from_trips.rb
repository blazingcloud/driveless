class RemoveIsHiddenFromTrips < ActiveRecord::Migration
  def self.up
    Trip.destroy_all(:is_hidden => true)
    remove_column :trips, :is_hidden
  end

  def self.down
    add_column :trips, :is_hidden, :boolean
  end
end
