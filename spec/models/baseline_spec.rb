require 'spec_helper'

describe Baseline do

  attr_reader :baseline, :current_challenge_start, :current_challenge_end

  before do
    @baseline = Baseline.new
    @current_challenge_start = Time.zone.local(Date.today.year, 4, 1)
    @current_challenge_end = Time.zone.local(Date.today.year, 5, 1) - 1
  end

  describe "#updated_by_user?" do
    it "should return true if updated_at is at least 1s > created_at" do
      mock(baseline).created_at { current_challenge_start }
      mock(baseline).updated_at { current_challenge_start + 1 }
      @baseline.updated_by_user?.should == true
    end

    it "should return true if updated_at is at least 1s > created_at" do
      mock(baseline).created_at { current_challenge_start }
      mock(baseline).updated_at { current_challenge_start + 0.05 }
      baseline.updated_by_user?.should == false
    end
  end

  describe "has_non_blank_values?" do 
    it "should return true if any numeric field is non-zero" do
      baseline.kids_green = 100.0 
      baseline.has_non_blank_values?.should == true
    end

    it "should return false if all numeric fields are zero" do
      baseline.has_non_blank_values?.should == false
    end
  end

  describe "updated_for_current_challenge?" do
    describe "when updated_by_user? and has_non_blank_values? are true" do
      before do
        stub(baseline).updated_by_user? {true}
        stub(baseline).has_non_blank_values? {true}
      end

      it "should return true if updated_at is in April of current challenge year" do
        stub(baseline).updated_at {current_challenge_start}
        baseline.updated_for_current_challenge?.should == true
        stub(baseline).updated_at {current_challenge_end}
        baseline.updated_for_current_challenge?.should == true
      end

      it "should return false if updated_at is outside April of current challenge year" do
        stub(baseline).updated_at {current_challenge_start - 1}
        baseline.updated_for_current_challenge?.should == false
        stub(baseline).updated_at {current_challenge_end + 1}
        baseline.updated_for_current_challenge?.should == false
      end

    end 

  end

end
