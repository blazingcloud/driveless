class Baseline < ActiveRecord::Base
  attr_accessible :user_id, :duration,
    :work_green,    :work_alone,
    :school_green,  :school_alone,
    :kids_green,    :kids_alone,
    :errands_green, :errands_alone,
    :faith_green,   :faith_alone,
    :social_green,  :social_alone,
    :total_miles,   :green_miles
end
