require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Unit.new.valid?
  end
end
