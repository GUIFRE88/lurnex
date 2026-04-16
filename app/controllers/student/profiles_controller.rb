module Student
  class ProfilesController < BaseController
    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(profile_params)
        redirect_to student_dashboard_path, notice: "Profile updated."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def profile_params
        params.require(:user).permit(:email_address, :password, :password_confirmation)
      end
  end
end
