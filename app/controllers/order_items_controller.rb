class OrderItemsController < ApplicationController
  def new
  end

  def create
    @order_item = OrderItem.new(order_item_params)

    if @order_item.save

      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  private
  def order_item_params
    params.require(:order_item).permit(:item_id, :quantity, :order_id)
  end
end
