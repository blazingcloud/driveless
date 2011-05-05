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

  context "prize result" do
    before do
      work = Destination.find_by_name("Work")
      work.should_not be_nil
      school = Destination.find_by_name("School")
      school.should_not be_nil
      walk = Mode.find_by_name("Bus")
      walk.should_not be_nil
      walk = Mode.find_by_name("Walk")
      walk.should_not be_nil
      bike = Mode.find_by_name("Bike")
      bike.should_not be_nil
      mile = Unit.find_by_name("Mile")
      mile.should_not be_nil
      @user1 = User.make
      @user1.save!
      # 6 green trips, 6 days
      # 39 greem miles, 30 miles bike, 9 miles walk
      @user1.trips.create!(:destination_id => work.id, :mode_id => bike.id,
                        :distance => 10.0, :unit_id => mile.id, :made_at => Date.today)
      @user1.trips.create!(:destination_id => work.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 1.day)
      @user1.trips.create!(:destination_id => work.id, :mode_id => bike.id,
                        :distance => 10.0, :unit_id => mile.id, :made_at => Date.today+ 2.day)
      @user1.trips.create!(:destination_id => work.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 3.day)
      @user1.trips.create!(:destination_id => work.id, :mode_id => bike.id,
                        :distance => 10.0, :unit_id => mile.id, :made_at => Date.today + 4.day)
      @user1.trips.create!(:destination_id => work.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 5.day)

      @user2 = User.make
      @user2.save!
      # 7 green trips in this challenge, 6 days (one trip last year)
      # 20 green miles, 20 miles walk
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 2.0, :unit_id => mile.id, :made_at => Date.today)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 1.day)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 4.0, :unit_id => mile.id, :made_at => Date.today + 2.day)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 2.0, :unit_id => mile.id, :made_at => Date.today + 3.day)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 4.day)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 6.day)
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 3.0, :unit_id => mile.id, :made_at => Date.today + 6.day)
                        
      @user2.trips.create!(:destination_id => school.id, :mode_id => walk.id,
                        :distance => 4.0, :unit_id => mile.id, :made_at => Date.today - 1.year)

    end
    it "should report the User with the max miles for a mode" do
      User.max_miles('Bike').should == {:user => @user1, :total_miles => 30.0, :name => 'Bike'}
    end
    it "should calculate max miles for walking with several users (ignoring last year)" do
      User.max_miles('Walk').should == {:user => @user2, :total_miles => 20.0, :name => 'Walk'}
    end
    it "should not return nil user and 0 total_miles if there is no one with a matching trip" do
      User.max_miles('Bus').should == {:user => nil, :total_miles => 0.0, :name => 'Bus'}
    end
    it "should report user with most green trips" do
      User.max_green_trips.should == {:user => @user2, :total_trips_count => 7.0 }
    end
  end
  describe ".to_csv" do
    attr_reader :csv_array
    before do
      User.make
      User.make
      User.make(:email => "ignore.me@my.drivelesschallenge.com")
      @csv = User.to_csv
      @csv_array = FasterCSV.parse(@csv)
    end

    it "should print a header line first" do
      csv_array.first.should include("Username")
    end

    it "all lines should have same number of fields" do
      num_fields = csv_array.first.size
      csv_array.each do |row|
        row.length.should == num_fields
      end 
    end

    it "should exclude users with emails from my.drivelesschallenge.com" do
      csv_array.length.should == User.count # Header increases count by one; there should only be one @my.drivelesschallenge.com email
    end
  end

  describe "#to_a_for_csv" do
    describe "if no parameters are passed" do
      attr_reader :user, :current_year, :earth_day

      before do
        @current_year = Date.today.year
        @user = User.make(
          :name => "sally alley",
          :username => "sally",
          :email => "sally@example.com",
          :address => "123 main",
          :city => "sf",
          :community => nil
        )
        @earth_day = Time.zone.local(current_year, 4, 22, 9)
        mock(user).created_at { earth_day }
      end
      
      it "should return an array of fields in string format" do
        user.to_a_for_csv.should == [
          user.id,
          "sally alley",
          "sally",
          "sally@example.com",
          "123 main", 
          "sf",
          "",
          "",
          "April 22, 2011 09:00",
          "no",
          0,
          "",
          "no"
        ]
      end

      describe "when user is a parent who lives in Palo Alto, has updated Baseline, and has logged a trip" do
        before do
          user.community = Community.find_by_name("Palo Alto")
          user.current_sign_in_at = Time.zone.local(current_year, 4, 22, 9)
          mock(user.baseline).updated_for_current_challenge? { true }
          attrs = {
            :destination_id => Destination.find_by_name("Work").id,
            :mode_id => Mode.find_by_name("Bike").id,
            :distance => 10.0,
            :unit_id => Unit.find_by_name("Mile").id,
            :made_at => Date.new(current_year, 4, 22)
          }
          user.trips.create!(attrs)
          user.is_parent = true
        end

        it "should return an array of fields with the proper values" do
          user.to_a_for_csv.should == [
            user.id,
            "sally alley",
            "sally",
            "sally@example.com",
            "123 main", 
            "sf",
            "Palo Alto",
            "April 22, 2011 09:00",
            "April 22, 2011 09:00",
            "yes",
            1,
            "2011-04-22",
            "yes"
          ]
        end
      end
    end
  end

  describe "leaderboards" do
    before do
      @fred = User.make
      @pete = User.make

      @bike = Mode.make(:name => "bike", :green => true, :lb_co2_per_mile => 2)
      @walk = Mode.make(:name => "walk", :green => true, :lb_co2_per_mile => 4)

      bike_trips = []
      walk_trips = []

      bike_trips << @fred.trips.make(:mode => @bike, :distance => 10, :made_at => Date.new(2011, 4, 23))
      bike_trips << @fred.trips.make(:mode => @bike, :distance => 5, :made_at => Date.new(2011, 4, 24))
      bike_trips << @pete.trips.make(:mode => @bike, :distance => 10, :made_at => Date.new(2011, 4, 25))

      walk_trips << @fred.trips.make(:mode => @walk, :distance => 5, :made_at => Date.new(2011, 4, 26))
      walk_trips << @pete.trips.make(:mode => @walk, :distance => 5, :made_at => Date.new(2011, 4, 27))

      @fred_bike_distance_sum = bike_trips.inject(0) {|sum, trip| sum += (trip.user == @fred) ? trip.distance : 0}
      @fred_bike_lb_co2_sum   = @fred_bike_distance_sum * @bike.lb_co2_per_mile

      @fred_walk_distance_sum = walk_trips.inject(0) {|sum, trip| sum += (trip.user == @fred) ? trip.distance : 0}
      @fred_walk_lb_co2_sum   = @fred_walk_distance_sum * @walk.lb_co2_per_mile

      @pete_bike_distance_sum = bike_trips.inject(0) {|sum, trip| sum += (trip.user == @pete) ? trip.distance : 0}
      @pete_bike_lb_co2_sum   = @pete_bike_distance_sum * @bike.lb_co2_per_mile

      @pete_walk_distance_sum = walk_trips.inject(0) {|sum, trip| sum += (trip.user == @pete) ? trip.distance : 0}
      @pete_walk_lb_co2_sum   = @pete_walk_distance_sum * @walk.lb_co2_per_mile

      @fred_distance_sum = @fred_bike_distance_sum + @fred_walk_distance_sum
      @fred_lb_co2_sum   = @fred_bike_lb_co2_sum + @fred_walk_lb_co2_sum

      @pete_distance_sum = @pete_bike_distance_sum + @pete_walk_distance_sum
      @pete_lb_co2_sum   = @pete_bike_lb_co2_sum + @pete_walk_lb_co2_sum
    end

    it "should return a friends leaderboard sorted by miles" do
      user = User.make
      user.friends << @fred << @pete

      bike_leaderboard = user.friends_leaderboard

      bike_leaderboard[0].should == @fred
      bike_leaderboard[0].distance_sum.to_i.should == @fred_distance_sum
      bike_leaderboard[0].lb_co2_sum.to_i.should == @fred_lb_co2_sum

      bike_leaderboard[1].should == @pete
      bike_leaderboard[1].distance_sum.to_i.should == @pete_distance_sum
      bike_leaderboard[1].lb_co2_sum.to_i.should == @pete_lb_co2_sum
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
      group = @fred.create_group({:name => "my group", :destination => Destination.make}, true)
      group.users << @fred << @pete

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
