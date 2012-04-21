class DataModeElectricCar < ActiveRecord::Migration
  def self.up
    Mode.create({:name => 'Electric Car',
                 :green => true,
                 :lb_co2_per_mile => 0.465,
                 :description => 'Electric Car'})
  end

  def self.down
  end
end
