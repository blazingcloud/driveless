class CreateBaselines < ActiveRecord::Migration
  def self.up
    create_table :baselines do |t|
      t.integer :user_id
      t.integer :duration
      t.timestamps
    end
  end
  
  def self.down
    drop_table :baselines
  end
end
