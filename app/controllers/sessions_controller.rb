class SessionsController < ApplicationController
  def new; end

  def create
    email = params.dig(:session, :email)
    password = params.dig(:session, :password)
    @user = User.find_by(email:)
    if @user&.authenticate password
      success_login @user
    else
      fail_login
    end
  end

  def destroy
    return unless logged_in?

    logout
    redirect_to root_path, status: :see_other
  end

  private
  def success_login user
    reset_session
    login user
    remember user if params.dig(:session, :remember_me) == "1"
    redirect_to user_path(id: user.id), status: :see_other
  end

  def fail_login
    flash.now[:danger] = t "login_fail"
    render :new, status: :unprocessable_entity
  end
end
