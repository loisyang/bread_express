class ItemPricesController < ApplicationController
  def index
    @all_item_prices = ItemPrice.chronological.paginate(page: params[:page]).per_page(7)
    @current_item_prices = ItemPrice.current.chronological.paginate(page: params[:page]).per_page(7)
  end

  def show
    @item_prices = ItemPrice.find(params[:id])
  end

  def new
    item = params[:item_param]
    @item_price = ItemPrice.new
    @item = item
    authorize! :new, @item_price    
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    authorize! :create, @item_price
    if @item_price.save
      # if saved to database
      flash[:notice] = "A new price for #{@item_price.item.name} has been created."
      redirect_to @item_price.item
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end
  private
  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end
end
