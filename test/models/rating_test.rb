require "test_helper"

class RatingTest < ActiveSupport::TestCase
  test "requires stars" do
    rating = Rating.new(song: songs(:one), user: users(:one))

    refute rating.valid?
    assert_includes rating.errors[:stars], "can't be blank"
  end

  test "stars must be within range" do
    rating = Rating.new(song: songs(:one), user: users(:one), stars: 6)

    refute rating.valid?
    assert_includes rating.errors[:stars], "is not included in the list"
  end

  test "user can only rate a song once" do
    rating = Rating.new(song: songs(:one), user: users(:one), stars: 4)

    refute rating.valid?
    assert_includes rating.errors[:user_id], "has already been taken"
  end

  test "defaults saved_to_library to false" do
    rating = Rating.new(song: songs(:one), user: users(:two), stars: 3)

    assert_equal false, rating.saved_to_library
  end
end
