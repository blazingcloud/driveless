require 'test_helper'

class LengthTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Length.new.valid?
  end
end
