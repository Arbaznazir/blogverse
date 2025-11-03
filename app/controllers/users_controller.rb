class UsersController < ApplicationController
  before_action :require_login!, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :require_owner!, only: [:edit, :update, :destroy]

  def new
    if logged_in?
      redirect_to root_path, notice: "You’re already signed in."
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "User created successfully!"
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def show

  end

  def edit
    
  end

  def update
    if @user.update(user_update_params)
      redirect_to @user, notice: "User updated successfully."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # require_owner! already runs; belt-and-suspenders is fine
    return redirect_to @user, alert: "Not your profile." unless owner?(@user)

    if @user.destroy
      reset_session
      cookies.delete(:user_id)
      redirect_to root_path, notice: "Your account and all posts were deleted. Goodbye!"
    else
      redirect_to @user, alert: "Could not delete the user."
    end
  end

  private 

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    if permitted[:password].blank?
      permitted.except(:password, :password_confirmation)
    else
      permitted
    end
  end

  def require_owner!
    return if owner?(@user)
    redirect_to @user, alert: "Not your profile."
  end

end
