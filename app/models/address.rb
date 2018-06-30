class Address < ApplicationRecord
  belongs_to :user_order

  def self.create_shipping_address(params,user_order)
    Address.transaction do
      @shipping_address = Address.new()
      @shipping_array = params[:shipping].split(',')
      @shipping_address.street = @shipping_array[0]
      @shipping_address.city = @shipping_array[1]
      @shipping_address.state = @shipping_array[2]
      @shipping_address.zipcode = @shipping_array[3]
      @shipping_address.name = @shipping_array[4]
      @shipping_address.apt = @shipping_array[5]
      @shipping_address.shipping = true
      @shipping_address.user_order = user_order
      @shipping_address.save
    end
    return @shipping_address
  end

  def self.create_billing_address(params,user_order)
    Address.transaction do
      @billing_address = Address.new()
      @billing_array = params[:billing].split(',')
      @billing_address.street = @billing_array[0]
      @billing_address.city = @billing_array[1]
      @billing_address.state = @billing_array[2]
      @billing_address.zipcode = @billing_array[3]
      @billing_address.name = @billing_array[4]
      @billing_address.apt = @billing_array[5]
      @billing_address.shipping = false
      @billing_address.user_order = user_order
      @billing_address.save
    end
    return @billing_address
  end

end
