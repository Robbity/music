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
end
