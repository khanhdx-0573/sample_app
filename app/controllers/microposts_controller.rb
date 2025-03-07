class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :find_post, only: :destroy
  def create
    @micropost = current_user.microposts.build post_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "micropost.create_success"
      redirect_to root_path, status: :see_other
    else
      @pagy, @feed_items = pagy current_user.feed,
                                limit: Settings.pagy_items
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.delete_success"
      redirect_to request.referer || root_path, status: :see_other
    else
      flash[:danger] = t "micropost.delete_fail"
      redirect_to request.referer || root_path, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:micropost).permit Micropost::MICROPOST_ATTRIBUTES
  end

  def find_post
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost.not_found"
    redirect_to root_path
  end
end
