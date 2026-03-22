require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email" do
    user = User.new(email: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email)
  end

  test "requires username" do
    user = User.new(email: "new@example.com", password: "password")

    refute user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "requires unique username" do
    user = User.new(username: users(:one).username, email: "unique@example.com", password: "password")

    refute user.valid?
    assert_includes user.errors[:username], "has already been taken"
  end
end
