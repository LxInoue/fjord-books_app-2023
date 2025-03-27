# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "name_or_emailは名前またはメールを返す" do
    alice = users(:alice)
    bob = users(:bob)
    bob.name = ''

    assert_equal alice.name, alice.name_or_email
    assert_equal bob.email, bob.name_or_email
  end
end
