class StripeService
  require 'stripe'

  # User buying now with a solo user order
  def self.buy_now_payment(params,user_order)
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => params[:amount],
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )
    user_order.charge_token = charge.id
    user_order.save
    rescue Stripe::CardError => e
      flash[:error] = e.message
  end

  # Only one user creating a bulk order
  def self.create_bulk_order_payment(params,user_order,bulk_order)
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
    if bulk_order.percent_filled >= bulk_order.max_amount
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => params[:amount],
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    else
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => params[:amount],
        :capture => false,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    end
    user_order.charge_token = charge.id
    user_order.save
    rescue Stripe::CardError => e
    flash[:error] = e.message
  end

  # User adding to exisiting bulk order
  def self.update_bulk_order_payment(params,user_order,bulk_order)
    if bulk_order.completed == true
      bulk_order.user_orders.each do |order|
        if order.charge_token && order.buy_now != true
        charge = Stripe::Charge.retrieve(order.charge_token)
        charge.capture
        end
      end
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => params[:amount],
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    else
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => params[:amount],
        :capture => false,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
      user_order.charge_token = charge.id
      user_order.save
    end
    rescue Stripe::CardError => e
    flash[:error] = e.message
  end

  def self.update_user_order_payment(params,user_order,bulk_order)
    charge_refund = Stripe::Charge.retrieve(user_order.charge_token)
    re = Stripe::Refund.create(
      charge: charge_refund
    )
    charge_refund.save

    amount = (user_order.total_price * 100)
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => amount,
      :capture => false,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )
    user_order.charge_token = charge.id
    user_order.save!

    if bulk_order.completed == true
      bulk_order.user_orders.each do |order|
        if order.charge_token && order.buy_now != true
          charge = Stripe::Charge.retrieve(UserOrder.find_by_id(order.id).charge_token)
          charge.capture
          end
        end
    end
    rescue Stripe::CardError => e
    flash[:error] = e.message
  end

end
