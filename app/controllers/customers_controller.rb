class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :check_login, except: [:new, :create]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  
  def index
    authorize! :index, @customer
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    authorize! :show, @customer
    @previous_orders = @customer.orders.chronological
  end

  def new
    # authorize! :new, @customer
    @customer = Customer.new
    @customer.build_user
  end

  def edit
    authorize! :edit, @customer
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    # should have a user associated with customer, but just in case...

  end

  def create
    # authorize! :create, @customer
    @customer = Customer.new(customer_params)
    @user = @customer.user
    if @customer.save
      session[:user_id] = @user.id
      redirect_to home_path,notice: "#{@customer.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    authorize! :update, @customer
    # just in case customer trying to hack the http request...
    # reset_username_param unless current_user.role? :admin
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    if current_user.nil?
    else
      reset_role_param unless current_user.role? :admin
    end
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active,user_attributes:[:username, :role, :password, :password_confirmation, :active])
  end

  def reset_role_param
    params[:customer][:user_attributes][:role] = "customer"
  end

  def reset_username_param
    params[:customer][:user_attributes][:username] = @customer.user.username
  end
end