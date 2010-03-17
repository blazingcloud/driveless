require 'test_helper'

class DestinationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Destination.new.valid?
  end
end
