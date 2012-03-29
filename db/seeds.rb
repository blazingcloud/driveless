# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Unit.create([
            :name => "Mile", :in_miles => 1.0
])

=begin
Mode            Description	                                    Pounds of CO2 Avoided per Mile
Bike	          Bike	                                          0.843
Walk	          Walk (includes skateboarad, rollerblade, etc)	  0.843
Bus	            Bus (e.g. VTA)	                                0.603
Train	          Train (e.g. Caltrain, BART)	                    0.473
Carpool	        Carpool (2 people or more)	                    0.422
Drove Car Alone	Solo Car Trips (assumes 24 mpg average, includes all categories of car, hybrid or electric, SUV, pickups )	0.000
=end


Mode.create([
            {:name => 'Walk',            :green => true,   :lb_co2_per_mile => 0.843, :description => 'Walk (includes skateboard, rollerblade, etc)'},
            {:name => 'Bike',            :green => true,   :lb_co2_per_mile => 0.843, :description => 'Bike'},
            {:name => 'Small Electric Vehicle',            :green => true,   :lb_co2_per_mile => 0.707, :description => 'Neighborhood Electric Vehicle, Low Speed Vehicle (20 - 25 mph maximum speed, not highway capable)'},
            {:name => 'Bus',             :green => true,   :lb_co2_per_mile => 0.603, :description => 'Bus (e.g. VTA)'},
            {:name => 'Train',           :green => true,   :lb_co2_per_mile => 0.473, :description => 'Train (e.g. Caltrain, BART)'},
            {:name => 'Carpool',         :green => true,   :lb_co2_per_mile => 0.422, :description => 'Carpool (2 people or more)'},
            {:name => 'Drove Car Alone', :green => false,  :lb_co2_per_mile => 0.000, :description => 'Drove Car Alone	Solo Car Trips (assumes 24 mpg average, includes all categories of car, hybrid or electric, SUV, pickups)'}
]) if Mode.count == 0

Destination.create([
                   {:name => 'Work'},
                   {:name => 'School'},
                   {:name => "Kids' Activities"},
                   {:name => 'Errands & Other'},
                   {:name => 'Faith Community'},
                   {:name => 'Social/Civic/Fun'}
]) if Destination.count == 0

["Palo Alto", "Menlo Park", "Mountain View", "Burlingame", "Los Altos/Hills", "Redwood City", "Cupertino", "Morgan Hill", "Sunnyvale","Elsewhere"].each do |community_name|
  Community.create!(:name => community_name, :state => 'California', :country => 'United States')
end if Community.count == 0

if User.count == 0
  u = User.create!(
    :email => 'change-me@example.com',
    :username => 'admin',
    :password => 'admin',
    :password_confirmation => 'admin',
    :name => "Administrator",
    :address => '218 Dell Ave',
    :city => 'Pittsburgh',
    :zip => '94102',
    :community => Community.first,
    :is_13 => true,
    :read_privacy => true
  ) 
  u.update_attribute(:admin, true)
end
