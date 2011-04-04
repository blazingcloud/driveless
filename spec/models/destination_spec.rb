require 'spec_helper'

describe Destination do
  xit { should be_invalid }
  xit { should have_many(:group) }
  xit { should have_named_scope(:by_name).with_order('name') }
  
  it "should create a new instance given valid attributes" do
    Invitation.make
  end
end