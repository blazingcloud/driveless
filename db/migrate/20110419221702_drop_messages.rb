class DropMessages < ActiveRecord::Migration
  def self.up
    drop_table :messages
  end

  def self.down
    raise "There is no going back"
  end
end
