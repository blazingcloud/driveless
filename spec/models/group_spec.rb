require 'spec_helper'

describe Group do
  it { should be_invalid }
  it { should have_many(:memberships) }
  it { should have_many(:users, :through => :memberships) }
  it { should have_one(:destinations) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:destination_id) }

  it "should create a new instance given valid attributes" do
    Group.make
  end

  context "when destroying" do
    context "with members" do
      it do
        users = owner = []
        2.times { users << User.make }
        owner << User.make
        group = Group.make(:users => users, :user_id => owner.id )
        expect do
          community.destroy
        end.to_not raise_error
      end
    end

    context "with no members" do
      it do
        community = Community.make
        expect do
          community.destroy
        end.to_not raise_error
      end
    end
  end
end
