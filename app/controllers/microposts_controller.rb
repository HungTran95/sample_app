class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "static_pages.home.mirocreate"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page]).per Settings.page
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "static_pages.home.micor_delete"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = t "static_pages.error.text_delete"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url unless @micropost
  end
end
