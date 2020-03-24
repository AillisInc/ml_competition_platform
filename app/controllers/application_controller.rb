# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  private

  def only_admin!
    redirect_to root_url, alert: 'Access Not Allowed' unless current_user.admin?
  end

  def only_admin_or_owner!(model)
    redirect_to root_url, alert: 'Access Not Allowed' unless current_user.admin? || current_user == model.user
  end

  def after_sign_in_path_for(resource)
    if resource.name.blank?
      edit_account_path
    else
      super
    end
  end
end
