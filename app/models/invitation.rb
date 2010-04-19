class Invitation < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user_id, :email, :name
  validates_format_of   :email,
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'email must be valid'

end
