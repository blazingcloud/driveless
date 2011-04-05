require 'spec_helper'

describe Length do
  it { should be_invalid }
  it { should has_one(:trip) }
  it { should has_one(:mode) }
  it { should has_one(:unit) }

  xit { should validate_attr_accessible }
  xit { should validate_numericality_of }

  it "should create a new instance given valid attributes" do
    Length.make
  end
end