require "test_helper"

class LibraryControllerTest < ActionDispatch::IntegrationTest
  test "index requires authentication" do
    get library_index_url

    assert_redirected_to new_user_session_path
  end

  test "index shows only saved ratings" do
    sign_in users(:one)
    ratings(:one).update!(saved_to_library: true, user: users(:one))
    ratings(:two).update!(saved_to_library: false, user: users(:one))

    get library_index_url

    assert_response :success
    assert_match ratings(:one).song.title, response.body
    refute_match ratings(:two).song.title, response.body
  end

  test "index sorts by rating" do
    sign_in users(:one)
    ratings(:one).update!(saved_to_library: true, user: users(:one), stars: 5)
    ratings(:two).update!(saved_to_library: true, user: users(:one), stars: 2)

    get library_index_url(sort: "rating")

    assert_response :success
    assert_match ratings(:one).song.title, response.body
    assert_match ratings(:two).song.title, response.body
    assert response.body.index(ratings(:one).song.title) < response.body.index(ratings(:two).song.title)
  end
end
