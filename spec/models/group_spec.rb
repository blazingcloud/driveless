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
end