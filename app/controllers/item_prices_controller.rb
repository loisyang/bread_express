class ItemPricesController < ApplicationController
  def index
    @all_item_prices = ItemPrice.chronological.paginate(page: params[:page]).per_page(7)
    @current_item_prices = ItemPrice.chronological.paginate(page: params[:page]).per_page(7)
  end

  def show
    @item_prices = ItemPrice.find(params[:id])
  end

end
