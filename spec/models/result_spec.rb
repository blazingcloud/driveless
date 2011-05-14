require 'spec_helper'

describe Result do
  attr_reader :result, :work, :school, :errands, :walk, :bike, :mile, :earth_day_2011, 
    :train, :car, :bus, :bike_to_school,
    :palo_alto, :sunnyvale, :users, :user1, :user2, :user3, :user4, :user5, :user6, :user7, :user8, 
    :user9, :user10

  before do
    @earth_day_2011 = Date.new(2011, 4, 22)
    @work = Destination.find_by_name("Work")
    @work.should_not be_nil
    @school = Destination.find_by_name("School")
    @school.should_not be_nil
    @errands = Destination.find_by_name("Errands & Other")
    @errands.should_not be_nil
    @bus = Mode.find_by_name("Bus")
    @bus.should_not be_nil
    @walk = Mode.find_by_name("Walk")
    @walk.should_not be_nil
    @bike = Mode.find_by_name("Bike")
    @bike.should_not be_nil
    @train = Mode.find_by_name("Train")
    @train.should_not be_nil
    @car = Mode.find_by_name("Drove Car Alone")
    @car.should be_present
    @mile = Unit.find_by_name("Mile")
    @mile.should_not be_nil
    @sunnyvale = Community.find_by_name("Sunnyvale")
    @sunnyvale.should be_present
    @palo_alto = Community.find_by_name("Palo Alto")
    @palo_alto.should be_present
  end

  describe "#calculate_stats_for_user(user)" do
    attr_reader :user

    describe "when a user has 5 or more trips" do
      before do
        @user = User.make
        @user.save!
        user.baseline.update_attributes!(
          :work_green => 0,    :work_alone => 10,
          :school_green => 10, :school_alone => 0,
          :errands_green => 0, :errands_alone => 15
        )
        user.baseline.current_total_miles.should == 35.0
        user.baseline.current_green_miles.should == 10.0

        add_trips_to_user(@user, :mode => bike, :destination => work,    :distances => [2.0]*5)      # 8.43 lbs co2 saved
        add_trips_to_user(@user, :mode => walk, :destination => work,    :distances => [0.5]*5)      # 2.1075
        add_trips_to_user(@user, :mode => bus,  :destination => work,    :distances => [8.0]*5)      # 24.12
        add_trips_to_user(@user, :mode => car,  :destination => work,    :distances => [3.0, 3.0])   # 0
        add_trips_to_user(@user, :mode => bike, :destination => errands, :distances => [10.0, 12.0]) # 18.546
        @user.community = sunnyvale
        @user.save!

        @result = Result.create_result_for(@user)
      end

      it "should include stats fields for the user" do
        result.walk_miles.should == 2.5
        result.days_logged.should == 5
        result.bus_miles.should == 40.0
        result.bike_miles.should == 32.0
        result.train_miles.should == 0.0
        result.community_name.should == sunnyvale.name
        result.baseline_pct_green.should == 10.0 / 35.0 * 100.0
        result.total_green_miles.should == 10.0 + 2.5 + 40.0 + 22.0
        total_miles = 10.0 + 2.5 + 40.0 + 22.0 + 6.0
        result.total_miles.should == total_miles
        result.total_green_trips.should == 17
        result.total_green_shopping_trips.should == 2
        actual_pct = (22.0 + 40.0 + 10.0 + 2.5) / (22.0 + 40.0 + 10.0 + 2.5 + 6.0) * 100.0
        result.actual_pct_green.should == actual_pct
        result.pct_improvement.should == actual_pct - ((10.0 / 35.0) * 100.0)
        total_lbs_co2_saved = 8.43 + 2.1075 + 24.12 + 0 + 18.546
        result.total_lbs_co2_saved.should be_within(0.01).of(total_lbs_co2_saved)
        result.lbs_co2_saved_per_mile.should be_within(0.01).of(total_lbs_co2_saved / total_miles)
        result.should be_qualified
      end
    end

    description "when user has fewer than 5 trips" do
      it "user should not be qualified" do
        user = User.make
        user.save!
        add_trips_to_user(@user, :mode => bike, :destination => work, :distances => [1.0, 2.0])
        user.trips.count.should == 2
        Results.create_result_for(user).should_not be_qualified
      end
    end
  end

  describe "when there are several users" do
    before do
      @users = [
        @user0  = user_with_trips(:mode => bike, :destination => work,    :community => sunnyvale, :distances => [0.5]*5),
        @user1  = user_with_trips(:mode => bike, :destination => work,    :community => sunnyvale, :distances => [1.0]*5),
        @user2  = user_with_trips(:mode => walk, :destination => school,  :community => sunnyvale, :distances => [2.0]*5),
        @user3  = user_with_trips(:mode => bike, :destination => work,    :community => sunnyvale, :distances => [3.0]*5),
        @user4  = user_with_trips(:mode => walk, :destination => school,  :community => sunnyvale, :distances => [5.0]*5),
        @user5  = user_with_trips(:mode => bike, :destination => errands, :community => sunnyvale, :distances => [4.0]*5),
        @user6  = user_with_trips(:mode => bike, :destination => work,    :community => palo_alto, :distances => [1.1]*5),
        @user7  = user_with_trips(:mode => walk, :destination => school,  :community => palo_alto, :distances => [2.1]*5),
        @user8  = user_with_trips(:mode => bike, :destination => work,    :community => palo_alto, :distances => [3.1]*5),
        @user9  = user_with_trips(:mode => walk, :destination => school,  :community => palo_alto, :distances => [5.1]*5),
        @user10 = user_with_trips(:mode => bike, :destination => errands, :community => palo_alto, :distances => [4.1]*5),
        @user11 = user_with_trips(:mode => bike, :destination => errands, :community => palo_alto, :distances => [1.0, 1.0]),
      ]
    end
  end
end
