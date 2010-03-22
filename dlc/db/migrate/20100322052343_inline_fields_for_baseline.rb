class InlineFieldsForBaseline < ActiveRecord::Migration
  def self.up
    add_column :baselines, :work_green, :decimal
    add_column :baselines, :work_alone, :decimal

    add_column :baselines, :school_green, :decimal
    add_column :baselines, :school_alone, :decimal

    add_column :baselines, :kids_green, :decimal
    add_column :baselines, :kids_alone, :decimal

    add_column :baselines, :errands_green, :decimal
    add_column :baselines, :errands_alone, :decimal

    add_column :baselines, :faith_green, :decimal
    add_column :baselines, :faith_alone, :decimal

    add_column :baselines, :social_green, :decimal
    add_column :baselines, :social_alone, :decimal

    drop_table :baseline_trips
  end

  def self.down
    remove_column :baselines, :work_green
    remove_column :baselines, :work_alone

    remove_column :baselines, :school_green
    remove_column :baselines, :school_alone

    remove_column :baselines, :kids_green
    remove_column :baselines, :kids_alone

    remove_column :baselines, :errands_green
    remove_column :baselines, :errands_alone

    remove_column :baselines, :faith_green
    remove_column :baselines, :faith_alone

    remove_column :baselines, :social_green
    remove_column :baselines, :social_alone
  end
end
