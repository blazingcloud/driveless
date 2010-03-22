require 'test_helper'

class ModeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Mode.new.valid?
  end
end
