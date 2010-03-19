class CreateLengths < ActiveRecord::Migration
  def self.up
    create_table :lengths do |t|
      t.integer :trip_id
      t.integer :mode_id
      t.decimal :distance
      t.integer :unit_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :lengths
  end
end
