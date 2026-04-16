class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
    @invite_token = params[:invite_token]
  end

  def create
    @user = User.new(user_params)
    invite = Invite.pending.find_by(token: params[:invite_token])

    ActiveRecord::Base.transaction do
      @user.save!
      if invite
        invite.accept_for!(@user)
      else
        organization = Organization.create!(name: params[:organization_name])
        Membership.create!(user: @user, organization:, role: :admin)
      end
    end

    if @user.persisted?
      start_new_session_for(@user)
      redirect_to after_authentication_url, notice: "Account created successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end

  private
    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end
end
