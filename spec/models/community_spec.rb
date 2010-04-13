require 'spec_helper'

describe Community do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :state => "value for state",
      :country => "value for country",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Community.create!(@valid_attributes)
  end
end
