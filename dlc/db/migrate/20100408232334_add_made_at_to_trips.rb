class AddMadeAtToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :made_at, :date
    Trip.find(:all).each{|trip|
      trip.made_at = trip.created_at
      trip.save!
    }
  end

  def self.down
    remove_column :trips, :made_at
  end
end
