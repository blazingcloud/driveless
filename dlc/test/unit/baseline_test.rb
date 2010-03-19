require 'test_helper'

class BaselineTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Baseline.new.valid?
  end
end
