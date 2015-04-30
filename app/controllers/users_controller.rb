class UsersController < ApplicationController
  before_action :check_login, on: [:edit, :update]

  def new
  	@user = User.new
  end

  def edit
  	@user= current_user
  end

  def create
  	@user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render :action => "new"
    end
  end

  def update
  	@user = current_user
    if @user.update_attributes(user_params) # update_attribute is what?
      redirect_to home_path
    else
      render :action => "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :role, :password, :password_confirmation, :active)
  end
  
end
