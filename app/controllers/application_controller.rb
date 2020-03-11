# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  private

  def only_admin!
    redirect_to root_url, alert: 'Access Not Allowed' unless current_user.admin?
  end

  def after_sign_in_path_for(resource)
    if resource.name.blank?
      edit_account_path
    else
      super
    end
  end
end
