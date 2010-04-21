class AddDescriptionToMode < ActiveRecord::Migration
  def self.up
    add_column :modes, :description, :string
  end

  def self.down
    remove_column :modes, :description
  end
end
