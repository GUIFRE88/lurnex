require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid attributes" do
    assert_difference("User.count", 1) do
      post registration_path, params: {
        user: {
          email_address: "new-user@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid attributes" do
    assert_no_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "invalid-user@example.com",
          password: "password123",
          password_confirmation: "different"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
