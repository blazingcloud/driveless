class Prizewinner < ActiveRecord::Base
  
  # @user = User.find(params[:user][:id][:green_miles])
  
  # most_green_miles_walking = self.Prizewinner(:walking)
  # most_green_miles_bus = self.Prizewinner(:bus)
  # most_green_miles_carpool = self.Prizewinner(:carpool)
  # most_green_miles_train = self.Prizewinner(:train)
  # most_green_miles_small_elec = self.Prizewinner(:small_elec)
  
  def self.most_green_miles
    where('green_miles LIKE ? OR mode LIKE ?', "%#{search}%", "%#{search}%")
  end
  
  def self.most_green_miles_city()
  end
  
  def self.most_green_trips_city()
  end
  
  def self.top_percentage_green_miles_city()
  end
  
  def self.most_improved_percentrage_city()
  end

  def self.most_improved_co2_city()
  end
  
end
