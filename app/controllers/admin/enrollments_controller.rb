module Admin
  class EnrollmentsController < BaseController
    def create
      course = current_organization.courses.find(params[:course_id])
      membership = current_organization.memberships.student.find(params[:membership_id])

      enrollment = current_organization.enrollments.new(course:, membership:)
      if enrollment.save
        CourseProgress.create!(enrollment:, percentage: 0)
        redirect_to admin_courses_path, notice: "Student enrolled."
      else
        redirect_to admin_courses_path, alert: enrollment.errors.full_messages.to_sentence
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_courses_path, alert: "Course or student not found."
    end
  end
end
