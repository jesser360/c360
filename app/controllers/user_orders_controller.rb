class UserOrdersController < ApplicationController
  require 'httparty'
  include HTTParty
  # basic_auth 'username', 'password'
  before_action :set_user_order, only: [:show, :edit, :update, :destroy]

  # GET /user_orders/1
  # GET /user_orders/1.json
  def show
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.where(item_name: params[:item])[0]
    @user_order =  UserOrder.find_by_id(params[:id])
    @bulk = @user_order.bulk_order
    @order_item = @user_order.order_item
  end

  # GET /user_orders/new
  def new
    @user_order = UserOrder.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find_by_id(params[:item])

  end

  # GET /user_orders/1/edit
  def edit
    @user_order =  UserOrder.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @order_item = @user_order.order_item
    @bulk = @user_order.bulk_order
  end

  # POST /user_orders
  # POST /user_orders.json
  def create
    # BUY NOW OPTION
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find_by_id(params[:item])
    @bulk_order = nil

    @order_item = OrderItem.create_order_item_from_item(@item)
    @user_order = UserOrder.create_buy_now_user_order(params[:user_order],@user,@order_item,@item)

    NotifMailer.single_order_email(@user,@bulk_order,@user_order).deliver
    NotifMailer.vendor_buy_now_email(@user_order).deliver

    respond_to do |format|
      if @user_order.save

        format.html { redirect_to user_path_url(@user) }
        format.json { render :show, status: :created, location: @user_order }
      else
        format.html { render :new }
        format.json { render json: @user_order.errors, status: :unprocessable_entity }
      end
    end

    StripeService::buy_now_payment(params,@user_order)
  end

  # PATCH/PUT /user_orders/1
  # PATCH/PUT /user_orders/1.json
  # EDIT EXISTING USER ORDER
  def update
    @user_order = UserOrder.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = @user_order.bulk_order
    @users = @bulk_order.users
    @order_item = @bulk_order.order_item
    @item = @bulk_order.item

    # Remove previous order amount from bulk_order
    @bulk_order.percent_filled = @bulk_order.percent_filled - (@bulk_order.user_orders.where(id:@user_order.id)[0].quantity)

    @user_order.quantity = params[:user_order][:quantity]
    @user_order.total_price = @user_order.quantity * @order_item.price
    @user_order.save

    # Add new amount to bulk order
    @bulk_order.percent_filled = @bulk_order.percent_filled + @user_order.quantity
    @bulk_order.save


    if @bulk_order.percent_filled >= @bulk_order.max_amount
      BulkOrder.bulk_order_fills(@bulk_order,@item,@order_item,@user,@user_order)
      BulkOrder.email_bulk_order_users(@bulk_order,@user,@user_order)
    end
    respond_to do |format|
      if @user_order.save
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user_order.errors, status: :unprocessable_entity }
      end
    end

    StripeService::update_user_order_payment(params,@user_order,@bulk_order)
  end

  # DELETE /user_orders/1
  # DELETE /user_orders/1.json
  def destroy
    @user_order = UserOrder.find(params[:id])
    @user = @user_order.user
    @bulk_order = @user_order.bulk_order

    @bulk_order.percent_filled = @bulk_order.percent_filled - @user_order.quantity
    @bulk_order.users.delete(@user)

    @user_order.destroy
    if @bulk_order.percent_filled < 1
      @bulk_order.destroy
      @order_item = @bulk_order.order_item
      @order_item.destroy
    else
      @bulk_order.save
    end
    respond_to do |format|
      format.html { redirect_to user_path_url(@user)}
      format.json { head :no_content }
    end
    charge = Stripe::Charge.retrieve(@user_order.charge_token)
    re = Stripe::Refund.create(
      charge: charge
    )
    charge.save
  end

  private

    def set_user_order
      @user_order = UserOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_order_params
      params.permit( :user_id, :bulk_order_id, :quantity,:item, :price, :amount, :stripeToken)
    end
end
