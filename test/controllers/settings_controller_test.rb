require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "show requires authentication" do
    get settings_url

    assert_redirected_to new_user_session_path
  end

  test "show succeeds when signed in" do
    sign_in users(:one)

    get settings_url

    assert_response :success
  end
end
