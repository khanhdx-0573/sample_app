module SessionsHelper
  def login user
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def logout
    session.delete :user_id
    @current_user = nil
  end
end
