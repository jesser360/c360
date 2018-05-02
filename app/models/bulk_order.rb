class BulkOrder < ApplicationRecord
has_many :user_orders
has_and_belongs_to_many :users
belongs_to :item
belongs_to :order_item
attr_accessor :amount


  def self.create_bulk_order(item,order_item,date,user_order,user)
    BulkOrder.transaction do
      @bulk_order = BulkOrder.new()
      @bulk_order.item = item
      @bulk_order.order_item = order_item
      @bulk_order.user_orders.push(user_order)
      @bulk_order.users.push(user)

      @bulk_order.expire_date = (date+(rand(1..10))).to_s
      @bulk_order.max_amount= order_item.bulk_order_amount
      @bulk_order.completed = false
      @bulk_order.percent_filled = user_order.quantity
      @bulk_order.save
    end
    return @bulk_order
  end

  def self.bulk_order_fills(bulk_order,item,order_item,user,user_order)
    item.current_amount = (item.current_amount - item.bulk_order_amount)
    item.save!

    order_item.current_amount = item.current_amount
    order_item.closed = true
    order_item.save!

    bulk_order.completed = true
    bulk_order.save!
  end

  def self.email_bulk_order_users(bulk_order,user,user_order)
    if bulk_order.users.count > 1
      bulk_order.users.each do |user|
        user_order = bulk_order.user_orders.where(user_id: user.id)[0]
        NotifMailer.single_order_email(user,bulk_order,user_order).deliver
      end
    else
      NotifMailer.single_order_email(user,bulk_order,user_order).deliver
    end
    NotifMailer.vendor_email(bulk_order).deliver
  end

end
