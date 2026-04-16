require "test_helper"

class SecurityFlowsTest < ActionDispatch::IntegrationTest
  test "student cannot access admin dashboard" do
    sign_in_as(users(:two))

    get admin_dashboard_path

    assert_redirected_to student_dashboard_path
  end

  test "admin sees only own organization courses" do
    sign_in_as(users(:one))

    get admin_courses_path

    assert_response :success
    assert_includes response.body, "Ruby Basics"
    assert_not_includes response.body, "Rails Advanced"
  end

  test "invite token redirects unauthenticated user to registration" do
    get invite_path("token-one")

    assert_redirected_to new_registration_path(invite_token: "token-one")
  end
end
