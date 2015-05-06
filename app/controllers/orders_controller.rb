class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping
  include BreadExpressHelpers::Baking


  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
      get_baking_list
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
    @order = Order.new
    @cart_items = get_list_of_items_in_cart
    @customer = Customer.find_by(user_id: @current_user.id)
    @shipping_cost = calculate_cart_shipping
    @cart_cost = calculate_cart_items_cost
    @grand_total = @shipping_cost + @cart_cost
    save_each_item_in_cart(@order)
  end

  def create
    @customer = Customer.find_by(user_id: @current_user.id)
    @shipping_cost = calculate_cart_shipping
    @cart_cost = calculate_cart_items_cost
    @grand_total = @shipping_cost + @cart_cost

    @order = Order.new(order_params)
    @order.grand_total = @grand_total
    @order.customer_id = @customer.id
    @order.date = Date.today
    if @order.save
      @order.pay
      save_each_item_in_cart(@order)
      destroy_cart
      create_cart
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def mark_shipped
    @order_item_id = params[:order_item_param]
    @order_item = OrderItem.find_by(id: @order_item_id)
    @order_item.shipped_on = Date.today
    @order_item.save!
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  private
  def get_baking_list
    @muffins_baking_list = create_baking_list_for(:muffins)
    @bread_baking_list = create_baking_list_for(:bread)
    @pastries_baking_list = create_baking_list_for(:pastries)
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params[:order][:expiration_month] = params[:order][:expiration_month].to_i 
    params[:order][:expiration_year] = params[:order][:expiration_year].to_i 
    params.require(:order).permit(:address_id, :credit_card_number, :expiration_year, :expiration_month, :customer_id)
  end
end