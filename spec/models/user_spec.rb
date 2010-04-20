require 'spec_helper'

describe User do
  it { should be_invalid }
  it { should have_one(:baseline) }
  it { should have_many(:trips) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:groups).through(:memberships) }
  it { should belong_to(:community) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  #it { should validate_presence_of(:password) } # This is disabled by Casey so users can register by OpenId.

  it "should create a new instance given valid attributes" do
    User.make
  end

  describe "leaderboards" do
    before do
      @fred = User.make
      @pete = User.make

      @bike = Mode.make(:name => "bike", :green => true, :lb_co2_per_mile => 2)
      @walk = Mode.make(:name => "walk", :green => true, :lb_co2_per_mile => 4)

      bike_trips = []
      walk_trips = []

      bike_trips << @fred.trips.make(:mode => @bike, :distance => 10)
      bike_trips << @fred.trips.make(:mode => @bike, :distance => 5)
      bike_trips << @pete.trips.make(:mode => @bike, :distance => 10)

      walk_trips << @fred.trips.make(:mode => @walk, :distance => 5)
      walk_trips << @pete.trips.make(:mode => @walk, :distance => 5)

      @fred_bike_distance_sum = bike_trips.inject(0) {|sum, trip| sum += (trip.user == @fred) ? trip.distance : 0}
      @fred_bike_lb_co2_sum   = @fred_bike_distance_sum * @bike.lb_co2_per_mile

      @pete_bike_distance_sum = bike_trips.inject(0) {|sum, trip| sum += (trip.user == @pete) ? trip.distance : 0}
      @pete_bike_lb_co2_sum   = @pete_bike_distance_sum * @bike.lb_co2_per_mile
    end

    it "should return a friends leaderboard filtered by mode" do
      user = User.make
      user.friends << @fred << @pete

      bike_leaderboard = user.friends_leaderboard_by(@bike)

      bike_leaderboard[0].should == @fred
      bike_leaderboard[0].distance_sum.to_i.should == @fred_bike_distance_sum
      bike_leaderboard[0].lb_co2_sum.to_i.should == @fred_bike_lb_co2_sum

      bike_leaderboard[1].should == @pete
      bike_leaderboard[1].distance_sum.to_i.should == @pete_bike_distance_sum
      bike_leaderboard[1].lb_co2_sum.to_i.should == @pete_bike_lb_co2_sum
    end

    it "should return a group members leaderboard filtered by mode" do
      group = @fred.create_group(:name => "my group", :destination => Destination.make)
      group.users << @pete

      bike_leaderboard = group.members_leaderboard_by(@bike)

      bike_leaderboard[0].should == @fred
      bike_leaderboard[0].distance_sum.to_i.should == @fred_bike_distance_sum
      bike_leaderboard[0].lb_co2_sum.to_i.should == @fred_bike_lb_co2_sum

      bike_leaderboard[1].should == @pete
      bike_leaderboard[1].distance_sum.to_i.should == @pete_bike_distance_sum
      bike_leaderboard[1].lb_co2_sum.to_i.should == @pete_bike_lb_co2_sum
    end
  end
end
