require 'spec_helper'

describe Mode do
  context "#green" do
    it "should return all green modes" do
      Mode.green.all?(&:green).should be_true
    end
    it "should not return 'Drove Car Alone'" do
      alone = Mode.find_by_name('Drove Car Alone')
      alone.should_not be_nil
      Mode.green.should_not include(alone)
    end
    
  end
end