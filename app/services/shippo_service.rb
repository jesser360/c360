class ShippoService
  Shippo::API.token = ENV['SHIPPO_TOKEN']


  def self.create_shipment_buy_now(shipping_address,user_order)
    address_from = {
        :name => 'SC360 brokerage',
        :street1 => '4601 Stuart St',
        :city => 'Denver',
        :state => 'CO',
        :zip => '94117',
        :country => 'US',
        :phone => '+1 555 341 9393',
        :email => 'c360@gmail.com'
    }
    address_to = {
        :name => shipping_address.name,
        :street1 => shipping_address.street,
        :city => shipping_address.name,
        :state => shipping_address.state,
        :zip => shipping_address.zipcode,
        :country => 'US',
        :phone => '+1 555 341 9393',
        :email => user_order.buyer_email
    }
    parcel = {
        :length => 5,
        :width => 1,
        :height => 5.555,
        :distance_unit => :in,
        :weight => 2,
        :mass_unit => :lb
    }
    shipment = Shippo::Shipment.create(
        :address_from => address_from,
        :address_to => address_to,
        :parcels => parcel,
        :async => false
    )
    # Get the first rate in the rates results.
    # Customize this based on your business logic.
    @rate = shipment.rates.first
    # Purchase the desired rate.
    @transaction = Shippo::Transaction.create(
      :rate => @rate["object_id"],
      :label_file_type => "PDF",
      :async => false )
    # label_url and tracking_number
    if @transaction["status"] == "SUCCESS"
      user_order.tracking_number = @transaction.tracking_number
      user_order.tracking_label = @transaction.label_url
      user_order.save
    else
      puts "Error generating label:"
      puts @transaction.messages
    end
  end


  def self.create_shipments_bulk_order_fill(bulk_order)
    bulk_order.user_orders.each do |user_order|
      @shipping_address = user_order.addresses.where(shipping: true)[0]
      address_from = {
          :name => 'SC360 brokerage',
          :street1 => '4601 Stuart St',
          :city => 'Denver',
          :state => 'CO',
          :zip => '94117',
          :country => 'US',
          :phone => '+1 555 341 9393',
          :email => 'c360@gmail.com'
      }
      address_to = {
          :name => @shipping_address.name,
          :street1 => @shipping_address.street,
          :city => @shipping_address.name,
          :state => @shipping_address.state,
          :zip => @shipping_address.zipcode,
          :country => 'US',
          :phone => '+1 555 341 9393',
          :email => user_order.buyer_email
      }
      parcel = {
          :length => 5,
          :width => 1,
          :height => 5.555,
          :distance_unit => :in,
          :weight => 2,
          :mass_unit => :lb
      }
      shipment = Shippo::Shipment.create(
          :address_from => address_from,
          :address_to => address_to,
          :parcels => parcel,
          :async => false
      )
      # # Get the first rate in the rates results.
      # # Customize this based on your business logic.
      # @rate = shipment.rates.first
      # # Purchase the desired rate.
      # @transaction = Shippo::Transaction.create(
      #   :rate => @rate["object_id"],
      #   :label_file_type => "PDF",
      #   :async => false )
      # # label_url and tracking_number
      # if @transaction["status"] == "SUCCESS"
      #   user_order.tracking_number = @transaction.tracking_number
      #   user_order.tracking_label = @transaction.label_url
      #   user_order.save
      # else
      #   puts "Error generating label:"
      #   puts @transaction.messages
      # end
    end
  end

end
