class UserOrder < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :bulk_order, optional: true
  has_many :reviews
  has_many :addresses
  has_secure_token

  def to_param
   token
  end

  def self.create_user_order(params,user,bulk_order)
    UserOrder.transaction do
      @user_order = UserOrder.new()
      @user_order.quantity = params[:quantity]
      @user_order.user = user
      @user_order.total_price = @user_order.quantity * bulk_order.wholesale_price
      @user_order.buyer_email = params[:stripeEmail]
      @user_order.save
    end
    return @user_order
  end

  def self.create_buy_now_user_order(params,user,item,bulk_order)
    UserOrder.transaction do
      @user_order = UserOrder.new()
      @user_order.quantity = params[:quantity]
      @user_order.user = user
      @user_order.total_price = @user_order.quantity * bulk_order.market_price
      @user_order.bulk_order = bulk_order
      @user_order.buy_now = true
      @user_order.save!

    end
    return @user_order
  end


end
