class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "static_pages.email.mess_email"
      redirect_to root_url
    else
      flash.now[:danger] = t "static_pages.email.mess_email1"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("static_pages.account.password_error"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t "static_pages.account.password_has"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "static_pages.user.no_load"
    redirect_to root_path
  end

  def valid_user
    return if
      (@user.activated && @user.authenticated?(:reset, params[:id]))

    redirect_to root_url
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "static_pages.account.password_rs"
      redirect_to new_password_reset_url
    end
  end
end
