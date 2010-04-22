class AddIsHiddenToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :is_hidden, :boolean
  end

  def self.down
    remove_column :trips, :is_hidden
  end
end
