require 'test_helper'

class BaselineTripsTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BaselineTrips.new.valid?
  end
end
