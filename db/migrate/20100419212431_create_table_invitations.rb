class CreateTableInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :email, :null => false
      t.integer :user_id, :null => false
      t.text :invitation, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
