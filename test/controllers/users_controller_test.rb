require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid attributes" do
    assert_difference("User.count", 1) do
      assert_difference("Organization.count", 1) do
        assert_difference("Membership.count", 1) do
          post registration_path, params: {
            organization_name: "Carlos Estudos",
            user: {
              email_address: "new-user@example.com",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        end
      end
    end

    assert_redirected_to admin_dashboard_path
    assert cookies[:session_id]
  end

  test "create from invite with valid attributes" do
    invite = invites(:one)

    assert_difference("User.count", 1) do
      assert_no_difference("Organization.count") do
        post registration_path, params: {
          invite_token: invite.token,
          user: {
            email_address: invite.email_address,
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end
    end

    assert_redirected_to student_dashboard_path
    assert cookies[:session_id]
    assert invite.reload.accepted_at.present?
  end

  test "create with invalid attributes" do
    assert_no_difference("User.count") do
      post registration_path, params: {
        organization_name: "",
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
