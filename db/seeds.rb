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
Solo Car Trips (averaging 24 mpg)         0.843
Bus (VTA)         0.240
Train (Caltrain, BART)         0.370
Carpool (2 people)         0.422
Hybrid / Electric Car (averaging 50 mpg)         0.405
=end

Mode.create([
  {:name => 'Walk',                             :green => true,   :lb_co2_per_mile => 0.840},
  {:name => 'Bike',                             :green => true,   :lb_co2_per_mile => 0.840},
  {:name => 'Solo Car Trips (avg 24mpg)',       :green => true,   :lb_co2_per_mile => 0.843},
  {:name => 'Bus (VTA)',                        :green => true,   :lb_co2_per_mile => 0.240},
  {:name => 'Train (Caltrain,BART)',            :green => true,   :lb_co2_per_mile => 0.370},
  {:name => 'Carpool (2 people)',               :green => true,   :lb_co2_per_mile => 0.422},
  {:name => 'Hybrid/Electric Car (avg 50mpg)',  :green => true,   :lb_co2_per_mile => 0.405},
  {:name => 'Drive Alone',                      :green => false,  :lb_co2_per_mile => 0.000}
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
