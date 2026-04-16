module Admin
  class InvitesController < BaseController
    def index
      @invites = current_organization.invites.order(created_at: :desc)
    end

    def create
      invite = current_organization.invites.new(invite_params)
      invite.invited_by_membership = current_membership

      if invite.save
        redirect_to admin_invites_path, notice: "Invite created."
      else
        redirect_to admin_invites_path, alert: invite.errors.full_messages.to_sentence
      end
    end

    private
      def invite_params
        params.require(:invite).permit(:email_address, :role)
      end
  end
end
