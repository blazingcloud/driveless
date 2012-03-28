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
  context "#merge " do
    context "with a group and a group to merge" do
      before do
        @owner = User.make
        @destination = Destination.make(:name => 'Madison WI')
        @group = Group.make(:name => 'My Group', :owner => @owner, :destination => @destination)
        @group_to_merge = Group.make(:name        => 'This is a Group to Merge',
                                     :owner       => @owner,
                                     :destination => @destination)
      end
      it "if you merge with yourself you are not destroyed" do
        lambda  do
          @group.merge(@group)
        end.should change(Group,:count).by(0)
      end
      
      it "the old group is destroyed" do
        lambda  do
          @group.merge(@group_to_merge)
        end.should change(Group,:count).by(-1)
      end

      context "when there are no intersecting memebers" do
        before do
          @group_to_merge.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))
          @group_to_merge.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))
        end
        it "members are joined" do
          lambda  do
            @group.merge(@group_to_merge)
          end.should change(@group.users,:count).by(2)
        end
      end
      context "when a member belongs to both groups" do
        before do
          # one new member
          @group_to_merge.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))

          # existing member 
          both_group_user = User.make

          # existing member in both groups
          @group_to_merge.users << both_group_user
          @group.users << both_group_user
        end
        it "the member is not added again" do
          lambda  do
            @group.merge(@group_to_merge)
          end.should change(@group.users,:count).by(1)
        end
      end
    end
  end
  describe "statistics" do
    attr_reader :bike, :qualified_users, :unqualified_users, :group, :school
    before do
      @bike = Mode.find_by_name("Bike")
      @school = Destination.find_by_name("School")
      @qualified_users = (1..10).map do 
        user = user_with_trips(:mode => bike, :destination => school, :distances => [5.0]*5)
        user.save!
        user
      end
      @unqualified_users = (1..3).map do
        user = user_with_trips(:mode => bike, :destination => school, :distances => [5.0]*3)
        user.save!
        user
      end
      @group = Group.make(:name => "wacky cyclists", :destination => school)
      group.users = qualified_users + unqualified_users
      group.save!
      @group = Group.find_by_id(group.id)
      group.users.count.should == 13
    end

    describe "#qualified_users" do
      it "should return users who have logged 5 or more trips for current challenge" do
        group.qualified_users.count.should == 10
        group.qualified_users.map(&:id).should =~ qualified_users.map(&:id)
      end
    end

    describe "#lbs_co2_saved" do
      it "should return the amount of co2 saved by qualified users" do
        # lbs_co2_saved_per_mile * 5 miles * 5 trips * 10 qualified users
        group.lbs_co2_saved.should be_within(0.01).of(0.843 * 5 * 5 * 10)
      end
    end

    describe "#total_miles" do
      it "should return the total miles for qualified users within the qualified period" do
        group.total_miles.should be_within(0.01).of(250.0)
      end
    end

    describe "#category_name" do
      it "should return the category name for the group" do
        group.category_name.should == "School"
      end
    end

    describe "#qualified_for_current_challenge?" do
      it "should return true if the number of qualified users is > 2" do
        mock(group).qualified_users {[1,2,3,4,5]}
        group.should be_qualified_for_current_challenge
      end

      it "should return false if the number of qualified users is < 3" do
        mock(group).qualified_users {[1,2,]}
        group.should_not be_qualified_for_current_challenge
      end
    end
  end
end
