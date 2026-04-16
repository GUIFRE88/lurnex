module Admin
  class DashboardsController < BaseController
    def show
      @organization = current_organization
      @courses_count = @organization.courses.count
      @students_count = @organization.memberships.student.count
      @completed_count = @organization.enrollments.joins(:course_progress).where.not(course_progresses: { completed_at: nil }).count
    end
  end
end
