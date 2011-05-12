require 'spec_helper'

describe Group do
  it { should be_invalid }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:users).through(:memberships) }
  it { should belong_to(:owner) }
  it { should belong_to(:destination) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner_id) }
  it { should validate_presence_of(:destination_id) }

  it "should create a new instance given valid attributes" do
    Group.make
  end

  describe "statistics" do
    attr_reader :bike, :qualified_users, :unqualified_users, :group, :school
    before do
      @bike = Mode.find_by_name("Bike")
      @school = Destination.find_by_name("School")
      @qualified_users = [1..10].map do 
        user_with_trips(:mode => bike, :destination => school, :distances => [5.0]*5).save!
      end
      @unqualified_users = [1..3].map do
        user_with_trips(:mode => bike, :destination => school, :distances => [5.0]*3).save!
      end
      @group = Group.make(:name => "wacky cyclists")
      debugger
      group.users = qualified_users + unqualified_users
      group.save!
      @group = Group.find_by_id(group.id)
      group.users.count.should == 13
    end

    describe "#qualified_users" do
      it "should return users who have logged 5 or more trips for current challenge" do
        group.qualified_users.map(&:id).should =~ qualified_users.map(&:id)
      end
    end

    describe "#lbs_co2_saved_by_qualified_users" do
      it "should return the amount of co2 saved by qualified users" do

      end
    end
  end
end
