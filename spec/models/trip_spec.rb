require 'spec_helper'

describe Trip do
  describe "default scope" do
    describe "when trips exist for previous challenges" do
      attr_reader :user, :mode, :destination, :unit, :year, :previous_year
      before do
        @user = User.first
        user.should be_present
        @mode = Mode.find_by_name("Walk")
        mode.should be_present
        @destination = Destination.find_by_name("School")
        destination.should be_present
        @unit = Unit.find_by_name("Mile")
        unit.should be_present
        @year = Date.today.year
        @previous_year = year - 1
        current_challenge_start = Date.new(year, 4, 22) # Earth day of the current year
        Trip.count.should == 0
        Trip.create!(:user_id => user.id, :destination_id => destination.id, :mode_id => mode.id, :distance => 10, :unit_id => unit.id, :made_at => Date.new(previous_year, 4, 24))
        Trip.create!(:user_id => user.id, :destination_id => destination.id, :mode_id => mode.id, :distance => 10, :unit_id => unit.id, :made_at => Date.new(previous_year, 4, 25))
        Trip.create!(:user_id => user.id, :destination_id => destination.id, :mode_id => mode.id, :distance => 10, :unit_id => unit.id, :made_at => Date.new(previous_year, 4, 26))
        @my_trip_id = Trip.create!(:user_id => user.id, :destination_id => destination.id, :mode_id => mode.id, :distance => 10, :unit_id => unit.id, :made_at => Date.new(year, 4, 22)).id
        @user = User.find(@user.id)
      end

      it "should not show them when querying for trips" do
        Trip.count.should == 1
        Trip.all.size.should == 1
        Trip.find(:all).size.should == 1
      end

      it "should not show up in associations either" do
        @user.trips.count.should == 1
        @user.trips.size.should == 1
        @user.trips.all.size.should == 1
        @user.trips.find(:all).size.should == 1
      end

      it "should return first trip in current year for .first" do
        @user.trips.first.id.should == @my_trip_id
        Trip.first.id.should == @my_trip_id
      end

      it "should return first trip in current year for .last" do
        @user.trips.last.id.should == @my_trip_id
        Trip.last.id.should == @my_trip_id
      end

      it "should return trips in current challenge for scopes, too" do
        Trip.only_green.size.should == 1
        Trip.not_green.size.should == 0
      end

    end
  end
end