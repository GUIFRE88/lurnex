module Student
  class DashboardsController < BaseController
    def show
      @organization = current_organization
      @enrollments = current_membership.enrollments.includes(:course, :course_progress)
    end
  end
end
