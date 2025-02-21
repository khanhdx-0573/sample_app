class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    if @user&.authenticate params.dig(:session, :password)
      reset_session
      login @user
      redirect_to user_path(id: @user.id), status: :see_other
    else
      flash.now[:danger] = t "login_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
  end
end
