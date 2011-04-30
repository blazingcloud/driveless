require 'spec_helper'

describe Prizewinner do
  before :each do
    
  end
  
  describe "most_green_miles_mode" do  
    describe "biking" do
      it "should return most miles for biking" do
        Prizewinner.biking(:top) should_not == nil
        Prizewinner.biking(:top) should == winner
      end
    end
  
    describe "walking" do
      it "should return most miles for walking" do
        Prizewinner.walking(:top) should_not == nil
        Prizewinner.walking(:top) should == winner
      end
  
    end
    describe "bus" do
      it "should return most miles for bus" do
        Prizewinner.bus(:top) should_not == nil
        Prizewinner.bus(:top) should == winner
      end
  
    end
    describe "carpool" do
      it "should return most miles for carpool" do
        Prizewinner.carpool(:top) should_not == nil
        Prizewinner.carpool(:top) should == winner
      end
  
    end
    describe "train" do
      it "should return most miles for train" do
        Prizewinner.train(:top) should_not == nil
        Prizewinner.train(:top) should == winner
      end
  
    end
    describe "small_elec" do
      it "should return most miles for small_elec" do
        Prizewinner.small_elec(:top) should_not == nil
        Prizewinner.small_elec(:top) should == winner
      end
    end
  end
  
  describe "most_green_miles_city"
    describe "city1" do
      it "should return most miles for city1" do
        Prizewinner.city1(:top) should_not == nil
        Prizewinner.city1(:top) should == winner
      end
    end
    describe "city2" do
      it "should return most miles for city2" do
        Prizewinner.most_green_miles_city2(:top) should_not == nil
        Prizewinner.most_green_miles_city2(:top) should == winner
      end
    end
    describe "city3" do
      it "should return most miles for city3" do
        Prizewinner.most_green_miles_city3(:top) should_not == nil
        Prizewinner.most_green_miles_city3(:top) should == winner
      end
    end
    describe "city4" do
      it "should return most miles for city4" do
        Prizewinner.most_green_miles_city4(:top) should_not == nil
        Prizewinner.most_green_miles_city4(:top) should == winner
      end
    end
    describe "overall" do
      it "should return most miles for overall" do
        Prizewinner.most_green_miles_overall(:top) should_not == nil
        Prizewinner.most_green_miles_overall(:top) should == winner
      end
    end
  end
  
  describe "most_green_trips_city" do
    describe "city1" do
      it "should return most trips for city1" do
        Prizewinner.most_green_trips_city1(:top) should_not == nil
        Prizewinner.most_green_trips_city1(:top) should == winner
      end
    end
    describe "city2" do
      it "should return most trips for city2" do
        Prizewinner.most_green_trips_city2(:top) should_not == nil
        Prizewinner.most_green_trips_city2(:top) should == winner
      end
    end
    describe "city3" do
      it "should return most trips for city3" do
        Prizewinner.most_green_trips_city3(:top) should_not == nil
        Prizewinner.most_green_trips_city3(:top) should == winner
      end
    end
    describe "city4" do
      it "should return most miles for city4" do
        Prizewinner.most_green_trips_city4(:top) should_not == nil
        Prizewinner.most_green_trips_city4(:top) should == winner
      end
    end
    describe "overall" do
      it "should return most trips for overall" do
        Prizewinner.most_green_trips_overall(:top) should_not == nil
        Prizewinner.most_green_trips_overall(:top) should == winner
      end
    end
  end 
  describe "top_percentage_green_miles_city" do
    describe "city1" do
      it "should return most trips for city1" do
        Prizewinner.top_percentage_green_miles_city1(:top) should_not == nil
        Prizewinner.top_percentage_green_miles_city1(:top) should == winner
      end
    end
    describe "city2" do
      it "should return most trips for city2" do
        Prizewinner.top_percentage_green_miles_city2(:top) should_not == nil
        Prizewinner.top_percentage_green_miles_city2(:top) should == winner
      end
    end
    describe "city3" do
      it "should return most trips for city3" do
        Prizewinner.top_percentage_green_miles_city3(:top) should_not == nil
        Prizewinner.top_percentage_green_miles_city3(:top) should == winner
      end
    end
    describe "city4" do
      it "should return most miles for city4" do
        Prizewinner.top_percentage_green_miles_city4(:top) should_not == nil
        Prizewinner.top_percentage_green_miles_city4(:top) should == winner
      end
    end
    describe "overall" do
      it "should return most trips for overall" do
        Prizewinner.top_percentage_green_miles_overall(:top) should_not == nil
        Prizewinner.top_percentage_green_miles_overall(:top) should == winner
      end
    end
  end 
  
  
  describe "most_improved_percentage_city" do
    describe "city1" do
      it "should return most improved % for city1" do
        Prizewinner.most_improved_percentage_city1(:top) should_not == nil
        Prizewinner.most_improved_percentage_city1(:top) should == winner
      end
    end
    describe "city2" do
      it "should return most improved % for city2" do
        Prizewinner.most_improved_percentage_city2(:top) should_not == nil
        Prizewinner.most_improved_percentage_city2(:top) should == winner
      end
    end
    describe "city3" do
      it "should return most improved % for city3" do
        Prizewinner.most_improved_percentage_city3(:top) should_not == nil
        Prizewinner.most_improved_percentage_city3(:top) should == winner
      end
    end
    describe "city4" do
      it "should return most improved % for city4" do
        Prizewinner.most_improved_percentage_city4(:top) should_not == nil
        Prizewinner.most_improved_percentage_city4(:top) should == winner
      end
    end
    describe "overall" do
      it "should return most improved % for overall" do
        Prizewinner.most_improved_percentage_overall(:top) should_not == nil
        Prizewinner.most_improved_percentage_overall(:top) should == winner
      end
    end
  end
  
  describe "most_improved_co2_city" do
    describe "city1" do
      it "should return most improved co2 for city1" do
        Prizewinner.most_improved_co2_city1(:top) should_not == nil
        Prizewinner.most_improved_co2_city1(:top) should == winner
      end
    end
    describe "city2" do
      it "should return most improved co2 for city2" do
        Prizewinner.most_improved_co2_city2(:top) should_not == nil
        Prizewinner.most_improved_co2_city2(:top) should == winner
      end
    end
    describe "city3" do
      it "should return most improved co2 for city3" do
        Prizewinner.most_improved_co2_city3(:top) should_not == nil
        Prizewinner.most_improved_co2_city3(:top) should == winner
      end
    end
    describe "city4" do
      it "should return most improved co2 for city4" do
        Prizewinner.most_improved_co2_city4(:top) should_not == nil
        Prizewinner.most_improved_co2_city4(:top) should == winner
      end
    end
    describe "overall" do
      it "should return most improved co2 for overall" do
        Prizewinner.most_improved_co2_overall(:top) should_not == nil
        Prizewinner.most_improved_co2_overall(:top) should == winner
      end
    end
  end
  
end