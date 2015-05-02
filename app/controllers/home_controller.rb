class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    if logged_in?
      # get my orders
      if current_user.role? :customer
        @orders= current_user.orders.chronological.to_a
        order_ids = @orders.map(&:id)
        
        # get my paid orders
        @paid_orders = Order.for_customer(current_user).paid
      end
    end
  end

  def about
  end

  def privacy
  end

  def contact
  end






end