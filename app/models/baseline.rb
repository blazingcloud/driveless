class Baseline < ActiveRecord::Base
  FIELD_NAMES = [
    :duration,
    :work_green,    :work_alone,
    :school_green,  :school_alone,
    :kids_green,    :kids_alone,
    :errands_green, :errands_alone,
    :faith_green,   :faith_alone,
    :social_green,  :social_alone,
    :total_miles,   :green_miles
  ]
    
  attr_accessible(*([:user_id] + FIELD_NAMES))

  def updated_by_user?
    updated_at - created_at >= 1.0
  end

  def has_non_blank_values?
    !!FIELD_NAMES.detect {|field| self[field] }
  end

  def updated_for_current_challenge?
    updated_by_user? && has_non_blank_values? && 
    (updated_at >= current_challenge_start) && 
    (updated_at <= current_challenge_end)
  end

  def current_challenge_start
    Time.zone.local(Date.today.year, 1, 1)
  end

  def current_challenge_end
    Time.zone.local(Date.today.year + 1, 1, 1) - 1
  end

  def current_total_miles
    [:work_green,    :work_alone,
    :school_green,  :school_alone,
    :kids_green,    :kids_alone,
    :errands_green, :errands_alone,
    :faith_green,   :faith_alone,
    :social_green,  :social_alone,].sum {|attr| self[attr].to_f}
  end

  def current_green_miles
    [:work_green,
    :school_green,
    :kids_green,
    :errands_green,
    :faith_green,
    :social_green].sum {|attr| self[attr].to_f}
  end

  def percent_green
    if current_total_miles == 0
      0
    else
      current_green_miles / current_total_miles * 100.0
    end
  end
end
