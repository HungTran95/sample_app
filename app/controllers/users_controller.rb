class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, except: [:new, :index, :create]

  def index
    @users = User.paginate page: params[:page], per_page: Settings.perpa_setting
  end

  def show
    return if @user

    flash[:danger] = t "static_pages.home.nouser"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "static_pages.user.pleastext1"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t "static_pages.user.proupdate"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "static_pages.user.delete_user"
    else
      flash[:danger] = t "static_pages.user.error_delete"
    end
    redirect_to users_url
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "static_pages.user.plealogin"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "static_pages.user.no_load"
    redirect_to root_path
  end
end
