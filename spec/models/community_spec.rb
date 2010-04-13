require 'spec_helper'

describe Community do
  it { should be_invalid }
  it { should have_many(:users) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:country) }

  it "should create a new instance given valid attributes" do
    Community.make
  end

  context "when destroying" do
    context "with members" do
      it do
        users = []
        2.times { users << User.make }
        community = Community.make(:users => users)
        expect do
          community.destroy
        end.to raise_error
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
