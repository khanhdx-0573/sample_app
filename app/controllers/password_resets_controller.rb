class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
                only: %i(edit update)
  def new; end

  def create
    email = params.dig(:password_reset, :email)&.downcase
    @user = User.find_by(email:)
    if @user&.activated?
      @user.create_digest_reset
      @user.send_reset_email
      flash[:info] = t "user.check_email_reset_password"
    else
      flash.now[:danger] = t "user.email_not_found_or_not_activated"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    password = params.dig(:user, :password)
    if password.empty?
      flash.now[:danger] = t "user.password_empty"
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.update_columns reset_digest: nil, reset_sent_at: nil
      flash[:success] = t "user.password_reset_success"
      login @user
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit User::USER_RESET_PASSWORD_ATTRIBUTES
  end

  def find_user
    @user = User.find_by(email: params[:email])
    return @user if @user

    flash.now[:danger] = t "user.password_reset_fail"
    render :new, status: :unprocessable_entity
  end

  def valid_user
    return if @user&.authenticated?(:reset, params[:id]) && @user&.activated?

    flash[:danger] = t "user.password_reset_fail"
    redirect_to new_password_reset_path
  end

  def check_expiration
    return unless @user.check_expired_reset_token

    flash[:danger] = t "user.password_reset_expired"
    redirect_to new_password_reset_path
  end
end
