class AddIsGreenColumnToModes < ActiveRecord::Migration
  def self.up
    add_column :modes, :is_green, :boolean, :default => true
  end

  def self.down
    remove_column :modes, :is_green
  end
end
