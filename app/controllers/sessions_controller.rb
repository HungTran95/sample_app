class SessionsController < ApplicationController
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      flash[:success] = t("static_pages.user.lgsuccess")
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t("static_pages.home.invalid")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def new; end
end
