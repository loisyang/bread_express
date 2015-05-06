class OrderItemsController < ApplicationController

  def new
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    if @order_item.save
    else
      flash.now.alert = "Item is not successfully added to the order"
    end
  end

  # def check_shipped
  #   @order_item = OrderItem.find(params[:id])
  #   @order_item.shipped_on = Date.today
  #   order_item.save!
  # end

  private
  def order_item_params
    params.require(:order_item).permit(:item_id, :quantity, :order_id)
  end
end
