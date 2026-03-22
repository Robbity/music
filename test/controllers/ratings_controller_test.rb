require "test_helper"

class RatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    attach_audio(songs(:one))
    attach_audio(songs(:two))
  end

  test "create blocks rating own song" do
    sign_in users(:one)

    assert_no_difference("Rating.count") do
      post ratings_url, params: { rating: { song_id: songs(:one).id, stars: 4 } }
    end

    assert_redirected_to listen_index_path
  end

  test "create blocks duplicate rating" do
    sign_in users(:one)
    ratings(:one).update!(song: songs(:two), user: users(:one))

    assert_no_difference("Rating.count") do
      post ratings_url, params: { rating: { song_id: songs(:two).id, stars: 4 } }
    end

    assert_redirected_to listen_index_path
  end

  test "create succeeds for valid rating" do
    sign_in users(:one)
    song = songs(:two)
    song.update!(user: users(:two))

    assert_difference("Rating.count", 1) do
      post ratings_url, params: { rating: { song_id: song.id, stars: 3 } }
    end

    assert_redirected_to listen_index_path
  end

  test "update saves rating to library" do
    sign_in users(:one)
    rating = ratings(:one)
    rating.update!(saved_to_library: false, user: users(:one))

    patch rating_url(rating)

    assert_redirected_to listen_index_path
    assert rating.reload.saved_to_library
  end

  test "destroy removes rating" do
    sign_in users(:one)
    rating = ratings(:one)
    rating.update!(user: users(:one))

    assert_difference("Rating.count", -1) do
      delete rating_url(rating)
    end

    assert_redirected_to library_index_path
  end
end
