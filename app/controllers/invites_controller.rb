class InvitesController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    invite = Invite.pending.find_by(token: params[:token])
    return redirect_to new_session_path, alert: "Invite is invalid." unless invite

    if authenticated?
      invite.accept_for!(current_user)
      switch_current_organization!(invite.organization)
      redirect_to after_authentication_url, notice: "Invite accepted."
    else
      redirect_to new_registration_path(invite_token: invite.token)
    end
  end
end
