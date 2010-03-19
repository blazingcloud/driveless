class Trip < ActiveRecord::Base
  attr_accessible :user_id, :destination_id
end
