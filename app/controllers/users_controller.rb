class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.alphabetical.paginate(:page => params[:page]).per_page(7)
  end

  def show
    
  end

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
      def set_user
      @user = User.find(params[:id])
    end

    def user_params
      if current_user && current_user.role?(:admin)
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :active)  
      else
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :active)
      end
    end
  def user_params
    params.require(:user).permit(:username, :role, :password, :password_confirmation, :active)
  end
  
end
