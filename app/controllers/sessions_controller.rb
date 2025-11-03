class SessionsController < ApplicationController

  def new 
    redirect_to root_path, notice: "Already logged in." if logged_in?
  end

  def create 
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      reset_session

      session[:user_id] = user.id

      if params[:remember_me] == "1"
        cookies.signed[:user_id] = {
          value: user.id,
          expires: 2.weeks,
          httponly: true,
          same_site: :lax
        }
      end

      redirect_to(session.delete(:return_to) || root_path, notice: "Welcome back #{user.name}!")
    else 
      flash.now[:alert] = "Invalid email or password!"
      render :new, status: :unprocessable_entity
    end

  end

  def destroy 
    reset_session
    cookies.delete(:user_id)
    redirect_to root_path, notice: "Logged out!"
  end


end