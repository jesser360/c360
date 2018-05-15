class UserOrder < ApplicationRecord
  belongs_to :user
  belongs_to :bulk_order, optional: true
  belongs_to :order_item



  def self.create_user_order(params,user,order_item)
    UserOrder.transaction do
      @user_order = UserOrder.new()
      @user_order.quantity = params[:quantity]
      @user_order.user = user
      @user_order.total_price = @user_order.quantity * order_item.price
      @user_order.order_item = order_item
      @user_order.save
    end
    return @user_order
  end

  def self.create_buy_now_user_order(params,user,order_item,item)
    UserOrder.transaction do
      @user_order = UserOrder.new()
      @user_order.quantity = params[:quantity]
      @user_order.user = user
      @user_order.total_price = @user_order.quantity * order_item.market_price
      @user_order.order_item = order_item
      @user_order.buy_now = true
      @user_order.save!

      item.current_amount = (item.current_amount - item.bulk_order_amount)
      item.save!

      order_item.current_amount = item.current_amount
      order_item.closed = true
      order_item.save!
    end
    return @user_order
  end


end
