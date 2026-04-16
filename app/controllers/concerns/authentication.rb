module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user, :current_membership, :current_organization
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def current_user
      Current.user
    end

    def current_membership
      Current.membership
    end

    def current_organization
      Current.organization
    end

    def require_authentication
      unless resume_session
        request_authentication
        return
      end

      return if current_membership.present?

      terminate_session
      redirect_to new_registration_path, alert: "Your account is not linked to an organization."
      return
    end

    def resume_session
      Current.session ||= find_session_by_cookie
      return unless Current.session

      set_current_organization_context
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || scoped_dashboard_url
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
        session_store_current_organization(user)
        set_current_organization_context
      end
    end

    def terminate_session
      Current.session&.destroy
      cookies.delete(:session_id)
      session.delete(:current_organization_id)
      Current.organization = nil
      Current.membership = nil
      Current.session = nil
    end

    def switch_current_organization!(organization)
      session[:current_organization_id] = organization.id
      set_current_organization_context
    end

    def require_admin!
      return if current_membership&.admin?

      redirect_to student_dashboard_path, alert: "Access denied."
    end

    def set_current_organization_context
      membership = membership_for_current_organization || fallback_membership
      Current.membership = membership
      Current.organization = membership&.organization
      session[:current_organization_id] = membership&.organization_id
    end

    def membership_for_current_organization
      org_id = session[:current_organization_id]
      return if org_id.blank?

      Current.user.memberships.find_by(organization_id: org_id)
    end

    def fallback_membership
      Current.user.memberships.admin.first || Current.user.memberships.order(:created_at).first
    end

    def scoped_dashboard_url
      return admin_dashboard_url if current_membership&.admin?

      student_dashboard_url
    end

    def session_store_current_organization(user)
      membership = user.memberships.admin.first || user.memberships.order(:created_at).first
      session[:current_organization_id] = membership&.organization_id
    end
end
