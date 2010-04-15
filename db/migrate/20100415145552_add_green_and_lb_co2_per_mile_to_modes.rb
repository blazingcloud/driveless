class AddGreenAndLbCo2PerMileToModes < ActiveRecord::Migration
  def self.up
    add_column :modes, :green, :boolean
    add_column :modes, :lb_co2_per_mile, :float
  end

  def self.down
    remove_column :modes, :lb_co2_per_mile
    remove_column :modes, :green
  end
end
