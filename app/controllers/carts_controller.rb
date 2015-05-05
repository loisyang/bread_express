class CartsController < ApplicationController
  include BreadExpressHelpers::Cart

  def show
    @cart_items = get_list_of_items_in_cart
    @cart_cost =format_price(calculate_cart_items_cost)
  end

  def edit
    @cart_items = get_list_of_items_in_cart
  end

  def newCartItem
    if @cart.nil?
      @cart = create_cart
    end
    @item_id = params[:item_param]
    @item = Item.find_by(id: @item_id)
    add_item_to_cart(@item_id)
    @number_cart_items = get_list_of_items_in_cart.size
    @cart_cost = format_price(calculate_cart_items_cost)
  end

  def add
    @item_id = params[:item_param]
    @item = Item.find_by(id: @item_id)
    add_item_to_cart(@item_id)
    redirect_to :action => "show", :notice => "One more #{@item.name} item is added now!"
  end

  def clear
    clear_cart
    redirect_to :action => "show", :notice => "Your cart is cleared now!"
  end    

  def destory
    @item_id = params[:item_param]
    @item = Item.find_by(id: @item_id)
    remove_item_from_cart(@item_id)
    redirect_to :action => "show", :notice => "All #{@item.name} are deleted from your cart!"
  end

  private
  def format_price(price)
    "$" + format('%.02f',price)
  end
end