class CreateResultsAndModeMileages < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :user_id, :null => false
      t.integer :community_id
      t.integer :days_logged
      t.float :total_green_miles, :null => false, :default => 0.0
      t.float :total_miles, :null => false, :default => 0.0
      t.integer :total_green_trips, :null => false, :default => 0
      t.integer :total_green_shopping_trips, :null => false, :default => 0
      t.float :total_lbs_co2_saved, :null => false, :default => 0.0
      t.float :baseline_pct_green
      t.float :actual_pct_green
      t.float :pct_improvement
      t.float :lbs_co2_saved_per_mile, :null => false, :default => 0.0
      t.boolean :qualified, :null => false, :default => false
    end

    create_table :mode_mileages do |t|
      t.integer :user_id, :null => false
      t.integer :mode_id, :null => false
      t.integer :result_id, :null => false
      t.float :mileage, :null => false, :default => 0.0
      t.string  :mode_name
    end
  end

  def self.down
    drop_table :results
    drop_table :mode_mileages
  end
end
