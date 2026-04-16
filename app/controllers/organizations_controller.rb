class OrganizationsController < ApplicationController
  def switch
    organization = current_user.organizations.find(params[:organization_id])
    switch_current_organization!(organization)

    redirect_to after_authentication_url, notice: "Organization switched."
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, alert: "Organization not found."
  end
end
