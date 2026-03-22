require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  setup do
    attach_audio(songs(:one))
    attach_audio(songs(:two))
  end

  test "index requires authentication" do
    get songs_url

    assert_redirected_to new_user_session_path
  end

  test "index succeeds when signed in" do
    sign_in users(:one)

    get songs_url

    assert_response :success
  end

  test "index sorts by plays" do
    sign_in users(:one)
    song_one = songs(:one)
    song_two = songs(:two)
    song_one.update!(user: users(:one), plays_count: 10)
    song_two.update!(user: users(:one), plays_count: 2)

    get songs_url(sort: "plays")

    assert_response :success
    assert_match song_one.title, response.body
    assert_match song_two.title, response.body
    assert response.body.index(song_one.title) < response.body.index(song_two.title)
  end

  test "play increments count without authentication" do
    song = songs(:one)

    assert_difference("Song.find(#{song.id}).plays_count", 1) do
      post play_song_url(song)
    end

    assert_response :ok
  end
end
