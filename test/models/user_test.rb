require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email" do
    user = User.new(email: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email)
  end
end
