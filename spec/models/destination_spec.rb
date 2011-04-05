require 'spec_helper'

describe Destination do
  xit { should be_invalid }
  it { should have_many(:groups) }
  it { should have_named_scope(:by_name).finding(:order => 'name') }
  
  it "should create a new instance given valid attributes" do
    Invitation.make
  end
end