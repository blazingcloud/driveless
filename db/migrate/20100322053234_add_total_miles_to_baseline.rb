class AddTotalMilesToBaseline < ActiveRecord::Migration
  def self.up
    add_column :baselines, :total_miles, :decimal
    add_column :baselines, :green_miles, :decimal
  end

  def self.down
    remove_column :baselines, :green_miles
    remove_column :baselines, :total_miles
  end
end
