# frozen_string_literal: true

class AccountsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to root_url, notice: 'Successfully updated profile'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email)
  end
end
