class CreatePrizewinners < ActiveRecord::Migration
  def self.up
    create_table :prizewinners do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :prizewinners
  end
end
