class AddNameToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :name, :string, :null => false
  end

  def self.down
    remove_column :invitations, :name
  end
end
