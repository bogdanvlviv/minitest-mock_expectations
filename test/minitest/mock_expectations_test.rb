require "test_helper"

class Minitest::MockExpectationsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Minitest::MockExpectations::VERSION
  end
end
