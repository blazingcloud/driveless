class MoveToFloat < ActiveRecord::Migration
  def self.up
    %w(work_green work_alone school_green school_alone kids_green kids_alone errands_green errands_alone faith_green faith_alone social_green social_alone total_miles green_miles).each do |column|
      change_column :baselines, column, :float
    end
    change_column :trips, :distance, :float
  end

  def self.down
    %w(work_green work_alone school_green school_alone kids_green kids_alone errands_green errands_alone faith_green faith_alone social_green social_alone total_miles green_miles).each do |column|
      change_column :baselines, column, :integer
    end
    change_column :trips, :distance, :integer
  end
end
