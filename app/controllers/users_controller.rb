class UsersController < ApplicationController
  before_action :find_user, only: %i(show)
  def show
    find_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      flash[:success] = t "sign_up_success"
      redirect_to user_path(id: @user.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:id]
    return @user if @user

    flash[:danger] = t "user_not_found"
    redirect_to root
  end

  def users_params
    params.require(:user).permit(User::USER_ATTRIBUTES)
  end
end
