class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_follow, only: :destroy

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    if @user
      current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:danger] = t "static_pages.error.txt_error1"
      redirect_to root_url
    end
  end

  private

  def load_follow
    @relationship= Relationship.find_by(id: params[:id])

    return if @relationship

    flash[:danger] = t "static_pages.error.txt_errorloadfl"
    redirect_to root_path
  end
end
