class UserOrdersController < ApplicationController
  require 'httparty'
  require 'shippo'
  include HTTParty

  # basic_auth 'username', 'password'
  before_action :set_user_order, only: [:show, :edit, :update, :destroy]


  def search
    @user_order = UserOrder.find_by_token(params[:order_token])
    @buyer_email = params[:email]
    if !@user_order.nil? && @user_order.buyer_email == @buyer_email
      if @user_order.buy_now
        redirect_to user_order_buy_now_path_path(@user_order.token)
      elsif @user_order.bulk_order.completed
        redirect_to user_order_path(@user_order)
      else
        redirect_to edit_user_order_path(@user_order)
      end
    else
      redirect_to '/store'
      flash[:error] ='Order cannot be found'
    end
  end

  def find_previous_orders
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @user_order = UserOrder.find_by_token(params[:order_token])
    @bulk_order = @user_order.bulk_order
    @buyer_email = params[:email]
    if !@user_order.nil? && @user_order.buyer_email == @buyer_email
      unless @user_order.buy_now
        @open_orders = @user.user_orders.where(buy_now: nil)
        @open_orders.each do |order|
          if order.bulk_order == @user_order.bulk_order
            @user_order.duplicate = true
            order.duplicate = true
            order.save
          end
        end
      end
      @user_order.user = @user
      @user_order.save
      @bulk_order.users.push(@user)
      @bulk_order.save
      redirect_to user_path_url(@user)
      flash[:success] ='Order has been added to your profile!'
    else
      redirect_to user_path_url(@user)
      flash[:error] ='Order cannot be found'
    end
  end

  def combine_duplicates
    @user_order = UserOrder.find_by_token(params[:token])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = @user_order.bulk_order
    @other_orders = @user.user_orders.where(bulk_order_id: @bulk_order.id).where(buy_now: nil).where.not(id: @user_order.id)
    @other_orders.each do |order|
      @user_order.quantity += order.quantity
      @user_order.total_price += order.total_price
      @bulk_order.buyer_count -=1
      @bulk_order.users.delete(order.user)
      order.addresses.delete_all
      order.destroy
    end
    # ADD ONE INSTANCE OF USER IN ORDER AFTER DUPLICATES REMOVED
    @bulk_order.users.push(@user)
    @bulk_order.save
    @user_order.save
    redirect_to user_path_url(@user)
    flash[:success] ='Orders have been combined into one!'
  end
  # GET /user_orders/1
  # GET /user_orders/1.json
  def show
    @user_order =  UserOrder.find_by_token(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user_order.bulk_order
    @item = @bulk.item
    @existing_review = Review.where(item: @item).where(bulk_order: @bulk)[0]
    @request = HTTParty.post('https://api.goshippo.com/tracks/',
      :body => {
        # "carrier": "usps",
        # "tracking_number": @user_order.tracking_number
        "carrier":"shippo","tracking_number":"SHIPPO_TRANSIT"

      },
      :headers => {'Authorization':'ShippoToken shippo_test_02a0afc8eab896a9136878e824f8b43437e17243'})
      puts @request
      puts "REQUESTTTT"
    @shipping_address = @user_order.addresses.where(:shipping => true)[0]
    @billing_address = @user_order.addresses.where(:shipping => false)[0]
    @status = @request['tracking_status']['status']
    @status_message = @request['tracking_status']['status_details']
  end

  def show_buy_now
    @user_order =  UserOrder.find_by_token(params[:token])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user_order.bulk_order
    @item = @bulk.item
    @reviews = Review.where(item: @item)
    @existing_review = Review.where(item: @item).where(user_order: @user_order)[0]
    @request = HTTParty.post('https://api.goshippo.com/tracks/',
      :body => {
        # "carrier": "usps",
        # "tracking_number": @user_order.tracking_number
        "carrier":"shippo","tracking_number":"SHIPPO_TRANSIT"

      },
      :headers => {'Authorization':'ShippoToken shippo_test_1bf025e980d46aaea6ed705ebdb5ec4e3755edc1'})
    @shipping_address = @user_order.addresses.where(:shipping => true)[0]
    @billing_address = @user_order.addresses.where(:shipping => false)[0]
    @status = @request['tracking_status']['status']
    @status_message = @request['tracking_status']['status_details']
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
    @user_order =  UserOrder.find_by_token(params[:id])
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

    @user_order = UserOrder.create_buy_now_user_order(params,@user,@item,@bulk_order)

    @user_order.addresses.delete_all

    @shipping_address = Address.create_shipping_address(params,@user_order)
    @billing_address = Address.create_billing_address(params,@user_order)
    @buyer_email = params[:stripeEmail]
    @user_order.buyer_email = @buyer_email

    ShippoService::create_shipment_buy_now(@shipping_address,@user_order)

    if @user
      NotifMailer.single_order_email(@bulk_order,@user_order).deliver
      NotifMailer.vendor_buy_now_email(@user,@user_order,@item).deliver
    else
      NotifMailer.no_user_single_order_email(@bulk_order,@user_order).deliver
      # NotifMailer.no_user_vendor_buy_now_email(@user_order,@item).deliver
    end

    respond_to do |format|
      if @user_order.save
        if @user
          format.html { redirect_to user_path_url(@user) }
          format.json { render :show, status: :created, location: @user_order }
        elsif @user_order.buy_now
          format.html { redirect_to user_order_buy_now_path_path(@user_order) }
          format.json { render :show, status: :created, location: @user_order }
        else
          format.html { redirect_to edit_user_order_path(@user_order) }
          format.json { render :show, status: :created, location: @user_order }
        end
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
    @user_order = UserOrder.find_by_token(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = @user_order.bulk_order
    @users = @bulk_order.users
    @item = @bulk_order.item

    # Remove previous order amount from bulk_order
    @bulk_order.percent_filled = @bulk_order.percent_filled - (@bulk_order.user_orders.where(id:@user_order.id)[0].quantity)

    @user_order.quantity = params[:quantity]
    @user_order.total_price = @user_order.quantity * @bulk_order.wholesale_price
    @user_order.save

    @shipping_address = Address.create_shipping_address(params,@user_order)
    @billing_address = Address.create_billing_address(params,@user_order)

    # Add new amount to bulk order
    @bulk_order.percent_filled = @bulk_order.percent_filled + @user_order.quantity
    @bulk_order.save


    if @bulk_order.percent_filled >= @bulk_order.max_amount
      @bulk_order.completed = true
      BulkOrder.email_bulk_order_users(@bulk_order)
      ShippoService.create_shipments_bulk_order_fill(@bulk_order)
      @bulk_order.save!
    end

    respond_to do |format|
      if @user_order.save
        if @user
          format.html { redirect_to user_path_url(@user)}
        else
          format.html { redirect_to user_order_path(@user_order)}
        end
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
    @user_order = UserOrder.find_by_token(params[:id])
    @user = @user_order.user if @user_order.user
    @bulk_order = @user_order.bulk_order

    @user_order.addresses.delete_all

    @bulk_order.percent_filled = @bulk_order.percent_filled - @user_order.quantity
    @bulk_order.buyer_count -=1
    @bulk_order.users.delete(@user) if @user_order.user
    @bulk_order.save
    @user_order.destroy
    respond_to do |format|
      if @user
        format.html { redirect_to user_path_url(@user)}
      else
        format.html { redirect_to '/store'}
      end
    end
    charge = Stripe::Charge.retrieve(@user_order.charge_token)
    re = Stripe::Refund.create(
      charge: charge
    )
    charge.save
  end

  private

    def set_user_order
      @user_order = UserOrder.find_by_token(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_order_params
      params.permit( :user_id, :bulk_order_id, :quantity,:item, :price, :amount, :stripeToken,:args,:stripeEmail)
    end
end
