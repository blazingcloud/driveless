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

Mode.create([
  {:name => 'Walk'},
  {:name => 'Bike'},
  {:name => 'Bus'},
  {:name => 'Train'},
  {:name => 'Carpool'},
  {:name => 'Shuttle'},
  {:name => 'Drive Alone'},
])

Destination.create([
  {:name => 'Work'},
  {:name => 'School'},
  {:name => "Kids' Activities"},
  {:name => 'Errands'},
  {:name => 'Faith Community'},
  {:name => 'Social/Civic/Fun'}
])