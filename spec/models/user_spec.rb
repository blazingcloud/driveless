require 'spec_helper'

describe User do
  it { should be_invalid }
  it { should have_one(:baseline) }
  it { should have_many(:trips) }
  it { should have_many(:memberships) }
  it { should have_many(:groups, :through => :memberships) }
  it { should belong_to(:community) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }

  it "should create a new instance given valid attributes" do
    User.make
  end
end
