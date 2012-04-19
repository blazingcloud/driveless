require 'pp'
class DataEntryCities < ActiveRecord::Migration
  def self.up
      Community.transaction do
        current_communities = Community.all.map(&:name)

        master_list_cali_cities = [
          "Menlo Park"     , "Mountain View"  ,
          "Palo Alto"      , "Los Altos/Hills",
          "Foster City"    , "San Carlos"     ,
          "East Palo Alto" , "Burlingame"     ,
          "Sunnyvale"      , "Other"
        ]
        # [1,2,3] - [3,5,9] => [1,2]
        # take all of the current communities
        # that  exisit but arn't in the master list 
        # and remove them
        (current_communities -  master_list_cali_cities).each do |name|
          c = Community.find_by_name(name)
          puts "Removing #{c.name} as it is not on master  list"
          begin
            c.destroy
          rescue
            puts $!.message
          end
        end
        (master_list_cali_cities - current_communities).each do |name|
          c = Community.create!(:name    => name,
                            :state   => 'California',
                            :country => 'United States')
          puts "Creating #{c.name}"

        end
        pp Community.all.map(&:name)
    end
  end

  def self.down
  end
end
