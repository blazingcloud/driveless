require 'test_helper'

class TripTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Trip.new.valid?
  end
end
