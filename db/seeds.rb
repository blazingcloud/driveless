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
Mode Name in Application	Mode Description	Pounds of CO2 Avoided per Mile
Bike	Bike	0.843
Walk	Walk (includes skateboarad, rollerblade, etc)	0.843
Bus	Bus (e.g. VTA)	0.603
Train	Train (e.g. Caltrain, BART)	0.473
Carpool	Carpool (2 people or more)	0.422
Drove Car Alone	Solo Car Trips (assumes 24 mpg average, includes all categories of car, hybrid or electric, SUV, pickups )	0.000
=end

Mode.create([
  {:name => 'Walk (includes skateboarad, rollerblade, etc)', :green => true,   :lb_co2_per_mile => 0.843},
  {:name => 'Bike',                             :green => true,   :lb_co2_per_mile => 0.843},
  {:name => 'Solo Car Trips (avg 24mpg)',       :green => true,   :lb_co2_per_mile => 0.843},
  {:name => 'Bus (VTA)',                        :green => true,   :lb_co2_per_mile => 0.603},
  {:name => 'Train (Caltrain,BART)',            :green => true,   :lb_co2_per_mile => 0.473},
  {:name => 'Carpool (2 people)',               :green => true,   :lb_co2_per_mile => 0.422},
#  {:name => 'Hybrid/Electric Car (avg 50mpg)',  :green => true,   :lb_co2_per_mile => 0.405},
  {:name => 'Solo Car Trips (all cars)',        :green => false,  :lb_co2_per_mile => 0.000}
])

Destination.create([
  {:name => 'Work'},
  {:name => 'School'},
  {:name => "Kids' Activities"},
  {:name => 'Errands'},
  {:name => 'Faith Community'},
  {:name => 'Social/Civic/Fun'}
])

['Palo Alto', 'Menlo Park', 'Mountain View'].each do |community_name|
  Community.create!(:name => community_name, :state => 'California', :country => 'United States')
end

u = User.create!(
  :email => 'change-me@example.com',
  :username => 'admin',
  :password => 'admin',
  :password_confirmation => 'admin',
  :community => Community.first
)
u.update_attribute(:admin, true)
