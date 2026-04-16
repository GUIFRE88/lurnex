module Admin
  class CoursesController < BaseController
    def index
      @courses = current_organization.courses.order(created_at: :desc)
      @students = current_organization.memberships.student.includes(:user)
    end

    def new
      @course = current_organization.courses.new
    end

    def create
      @course = current_organization.courses.new(course_params)
      if @course.save
        redirect_to admin_courses_path, notice: "Course created."
      else
        flash.now[:alert] = @course.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    private
      def course_params
        params.require(:course).permit(:title, :description)
      end
  end
end
