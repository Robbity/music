require "test_helper"

class DailySongTest < ActiveSupport::TestCase
  test "requires date" do
    daily_song = DailySong.new(user: users(:one), song: songs(:one))

    refute daily_song.valid?
    assert_includes daily_song.errors[:date], "can't be blank"
  end

  test "enforces unique user and date" do
    existing = daily_songs(:today_one)
    daily_song = DailySong.new(user: existing.user, song: songs(:two), date: existing.date)

    refute daily_song.valid?
    assert_includes daily_song.errors[:user_id], "has already been taken"
  end
end
