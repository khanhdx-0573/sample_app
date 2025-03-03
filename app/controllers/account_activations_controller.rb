class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    activation_token = params[:id]
    if user && !user.activated? && user.authenticated?(:activation,
                                                       activation_token)
      user.activate
      login user
      flash[:success] = t "user.account_activated"
    else
      flash[:danger] = t "user.invalid_activation_link"
    end
    redirect_to root_path
  end
end
