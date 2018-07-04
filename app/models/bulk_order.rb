class BulkOrder < ApplicationRecord
has_many :user_orders
has_many :reviews
has_and_belongs_to_many :users
belongs_to :item
attr_accessor :amount


  def self.create_bulk_order(item,params)
    BulkOrder.transaction do
      @bulk_order = BulkOrder.new()
      @bulk_order.item = item
      @bulk_order.expire_date = Time.now + 7.days
      @bulk_order.max_amount= params[:max_amount]
      @bulk_order.market_price= params[:market_price]
      @bulk_order.wholesale_price= params[:wholesale_price]
      @bulk_order.item_name= item.item_name
      @bulk_order.description= item.description
      @bulk_order.completed = false
      @bulk_order.percent_filled = 0
      @bulk_order.buyer_count = 0
      @bulk_order.save
    end
    return @bulk_order
  end


  def self.email_bulk_order_users(bulk_order)
    # if bulk_order.users.count > 1
      bulk_order.user_orders.each do |user_order|
        NotifMailer.bulk_fill_buyer_email(bulk_order,user_order).deliver
      end
    # else
    #   # NotifMailer.single_order_email(bulk_order,user_order).deliver
    # end
    NotifMailer.vendor_email(bulk_order).deliver
  end

end
