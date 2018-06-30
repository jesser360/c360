class UserOrdersController < ApplicationController
  require 'httparty'
  include HTTParty
  # basic_auth 'username', 'password'
  before_action :set_user_order, only: [:show, :edit, :update, :destroy]

  # GET /user_orders/1
  # GET /user_orders/1.json
  def show
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user_order.bulk_order
    @item = @bulk.item
    @user_order =  UserOrder.find_by_id(params[:id])
    @existing_review = Review.where(item: @item).where(bulk_order: @bulk)[0]
  end

  def show_buy_now
    @user_order =  UserOrder.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user_order.bulk_order
    @item = @bulk.item
    @reviews = Review.where(item: @item)
    @existing_review = Review.where(item: @item).where(user_order: @user_order)[0]

  end

  # GET /user_orders/new
  def new
    @user_order = UserOrder.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = BulkOrder.find_by_id(params[:bulk_order])
    @item = @bulk_order.item
    @reviews = Review.where(item: @item)

  end

  # GET /user_orders/1/edit
  def edit
    @user_order =  UserOrder.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user_order.bulk_order
    @item = @bulk.item
    @seller = @item.user
  end

  # POST /user_orders
  # POST /user_orders.json
  def create
    # BUY NOW OPTION
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = BulkOrder.find_by_id(params[:bulk_order])
    @item = @bulk_order.item

    @user_order = UserOrder.create_buy_now_user_order(params[:user_order],@user,@item,@bulk_order)

    @user_order.addresses.delete_all

    @shipping_address = Address.create_shipping_address(params,@user_order)
    @billing_address = Address.create_billing_address(params,@user_order)


    # NotifMailer.single_order_email(@user,@bulk_order,@user_order).deliver
    # NotifMailer.vendor_buy_now_email(@user,@user_order,@item).deliver

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
    @item = @bulk_order.item

    # Remove previous order amount from bulk_order
    @bulk_order.percent_filled = @bulk_order.percent_filled - (@bulk_order.user_orders.where(id:@user_order.id)[0].quantity)

    @user_order.quantity = params[:user_order][:quantity]
    @user_order.total_price = @user_order.quantity * @bulk_order.wholesale_price
    @user_order.save

    @shipping_address = Address.create_shipping_address(params,@user_order)
    @billing_address = Address.create_billing_address(params,@user_order)

    # Add new amount to bulk order
    @bulk_order.percent_filled = @bulk_order.percent_filled + @user_order.quantity
    @bulk_order.save


    if @bulk_order.percent_filled >= @bulk_order.max_amount
      @bulk_order.completed = true
      BulkOrder.email_bulk_order_users(@bulk_order,@user,@user_order)
      @bulk_order.save!
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
    @bulk_order.buyer_count -=1
    @bulk_order.users.delete(@user)
    @user_order.addresses.delete_all
    @user_order.destroy
    if @bulk_order.percent_filled < 1
      @bulk_order.destroy
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
      params.permit( :user_id, :bulk_order_id, :quantity,:item, :price, :amount, :stripeToken,:args,:stripeEmail)
    end
end
