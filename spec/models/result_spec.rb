require 'spec_helper'

describe Result do
  attr_reader :result, :work, :school, :errands, :walk, :bike, :mile, :earth_day_2012, 
    :train, :car, :bus, :bike_to_school,
    :palo_alto, :sunnyvale, :menlo_park, :mountain_view,
    :users, :user1, :user2, :user3, :user4, :user5, :user6, :user7, :user8, 
    :user9, :user10

  before do
    @earth_day_2012 = Date.new(2012, 4, 22)
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
    @mountain_view = Community.find_by_name("Mountain View")
    mountain_view.should be_present
    @menlo_park = Community.find_by_name("Menlo Park")
    menlo_park.should be_present
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

  describe "scopes" do

    def make_fake_result(user_id, options)
      attrs = { :user_id => user_id, :qualified => true }.merge(options)
      Result.create!(attrs)
    end

    describe ".greenest_travel" do

      context "when there are fewer than five qualified users with values for lbs_co2_saved_per_mile" do
        before do
          make_fake_result(1, :lbs_co2_saved_per_mile => 10)
          make_fake_result(2, :lbs_co2_saved_per_mile => 100)
          make_fake_result(3, :lbs_co2_saved_per_mile => 30)
          make_fake_result(4, :lbs_co2_saved_per_mile => 0)
        end

        it "should display the qualified users sorted by lbs_of_co2_saved excluding zero values" do
          Result.greenest_travel.map(&:lbs_co2_saved_per_mile).should == [100.0, 30.0, 10.0]
        end

        context "when there are more than 5 users and there's a tie" do
          before do
            make_fake_result(5, :lbs_co2_saved_per_mile => 50, :days_logged => 14, :total_green_trips => 28)
            make_fake_result(6, :lbs_co2_saved_per_mile => 50, :days_logged => 13, :total_green_trips => 56)
            make_fake_result(7, :lbs_co2_saved_per_mile => 50, :days_logged => 13, :total_green_trips => 60)
            make_fake_result(8, :lbs_co2_saved_per_mile => 50, :days_logged => 14, :total_green_trips => 27)
          end

          it "should return the top five using days_logged and then total_green_trips as secondary and tertiary sorts" do
            Result.greenest_travel.map(&:user_id).should == [2, 5, 8, 7, 6]
          end

          describe ".greenest_travel_for(community)" do
            it "should return the results scoped to a community" do
              Result.limit(3).order(:user_id).each {|result| result.update_attribute(:community_id, menlo_park.id)}
              Result.greenest_travel_for(menlo_park).map(&:user_id).should == [2, 3, 1]
            end
          end

        end

      end

    end

  end

end
