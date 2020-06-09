class AccountActivationsController < ApplicationController
  before_action :load_us, only: :edit

  def edit
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "static_pages.account.acacount"
      redirect_to @user
    else
      flash[:danger] = t "static_pages.account.invalidac"
      redirect_to root_url
    end
  end

  private

  def load_us
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "static_pages.account.noload_email"
    redirect_to root_url
  end
end
