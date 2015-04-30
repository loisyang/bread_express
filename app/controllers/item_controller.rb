# Items
# Admin: 
# 1. be able to post pictures of their different items
# 2. upload photos for items and have them displayed on the item's show page  
# 3. see a price history of the item
# 4. change the price RIGHT THERE
# Customers:
# 1. current price
# 2. a list of similar items (itmes that are of the same category)
# Others:
# 1. If an item doesn't have a picture, it should be handled appropriately (and not look like a gaping hole in the page).

# Bread Express wants to be able to post pictures of their different items. An administrator should be able to upload photos for items and have them displayed on the item's show page. If an item doesn't have a picture, it should be handled appropriately (and not look like a gaping hole in the page).

# When an administrator sees the item's show page, he/she should also see a price history of the item as well as have an opportunity to change the price right there. Customers only see the current price, but they should also see a list of similar items (i.e., items that are of the same category) that they may also be interested in purchasing.



class ItemController < ApplicationController
  def index
  	@current_items = Item.active.alphabetical.paginate(page: params[:page]).per_page(12)
  end
  def show
  	
  end
end
