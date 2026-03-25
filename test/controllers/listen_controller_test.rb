require "test_helper"

class ListenControllerTest < ActionDispatch::IntegrationTest
  setup do
    attach_audio(songs(:one))
    attach_audio(songs(:two))
  end

  test "index succeeds and does not increment plays" do
    song = songs(:one)
    original_count = song.plays_count

    get listen_index_url

    assert_response :success
    assert_equal original_count, song.reload.plays_count
  end

  test "signed in can request prompt rating" do
    sign_in users(:one)

    get listen_index_url(prompt_rating_id: ratings(:one).id)

    assert_response :success
  end

  test "signed in sees daily song for today" do
    sign_in users(:one)

    get listen_index_url

    assert_response :success
    assert_match songs(:one).title, response.body
  end

  test "guest sees top rated song of today" do
    ratings(:one).update!(song: songs(:one), stars: 5, created_at: Time.zone.now)
    ratings(:two).update!(song: songs(:two), stars: 2, created_at: Time.zone.now)

    get listen_index_url

    assert_response :success
    assert_match songs(:one).title, response.body
  end
end
