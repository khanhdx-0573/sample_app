class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy
  def index
    @pagy, @users = pagy User.all, limit: Settings.pagy_items
  end

  def show
    @pagy, @microposts = pagy @user.microposts.newest,
                              limit: Settings.pagy_items
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      @user.send_activation_email
      flash[:warning] = t "user.account_not_activated"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update users_params
      flash[:success] = t "user.user_update_success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.user_delete_success"
    else
      flash[:danger] = t "user.user_delete_fail"
    end
    redirect_to users_path
  end

  private
  def find_user
    @user = User.find_by id: params[:id]
    return @user if @user

    flash[:danger] = t "user.user_not_found"
    redirect_to root
  end

  def users_params
    params.require(:user).permit(User::USER_ATTRIBUTES)
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "user.not_correct_user"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "user.not_admin"
    redirect_to root_path
  end
end
