require 'spec_helper'

describe Invitation do
  it { should be_invalid }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }

  xit { should validate_format_of(:email).with(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).with_message('email must be valid') }

  it "should create a new instance given valid attributes" do
    Invitation.make
  end
end