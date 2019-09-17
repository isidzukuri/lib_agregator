require 'test_helper'

class Library::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Library
  end
end
