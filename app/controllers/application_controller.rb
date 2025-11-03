class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?, :owner?

  def current_user 
    return @current_user if defined?(@current_user)
    uid = session[:user_id] || cookies.signed[:user_id]
    @current_user = uid ? User.find_by(id: uid) : nil
  end

  def logged_in?
    current_user.present?
  end

  def owner?(record)
    return false unless logged_in? && record.present?

    if record.respond_to?(:user_id)               # e.g., Post, Comment
      record.user_id == current_user.id
    elsif record.is_a?(User) || record.respond_to?(:id)  # e.g., User
      record.id == current_user.id
    else
      false
    end
  end

  private
  def require_login!
    return if logged_in?
    session[:return_to] = request.fullpath if request.get?
    redirect_to new_session_path, alert: "Please login first..."
  end

end
