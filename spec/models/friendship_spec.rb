require 'spec_helper'

describe Friendship do
  it { should be_invalid }

  it { should belong_to(:user) }
  it { should belong_to(:friend) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:friend_id) }
  xit { should validate_uniqueness_of(:user_id).scoped_to(:friend_id) }

  it "should create a new instance given valid attributes" do
    Friendship.make
  end
end