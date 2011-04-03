require 'spec_helper'

describe Friendship do
  it { should be_invalid }

  it { should belong_to(:user) }
  it { should belong_to(:friend).class_name('User') }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:user_id).scope(:friend_id) }

  it "should create a new instance given valid attributes" do
    Friendship.make
  end
end