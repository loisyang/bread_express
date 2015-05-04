module OrdersHelper
  # create a helper to get the options for the address select menu
  # will return an array with key being recipient : address so 
  # that customers can choose the right address for this order
  def get_address_options
    Address.active.by_recipient.map{|add| ["#{add.recipient} : #{add.street_1}", add.id] }
  end

  def get_address_options_for_customer(customer)
    options = Address.active.by_recipient.select{|address| address.customer_id == customer.id}
    options.map{|add| ["#{add.recipient} : #{add.street_1}", add.id] }
  end
end
