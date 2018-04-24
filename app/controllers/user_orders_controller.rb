class UserOrdersController < ApplicationController
  before_action :set_user_order, only: [:show, :edit, :update, :destroy]

  # GET /user_orders/1
  # GET /user_orders/1.json
  def show
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.where(item_name: params[:item])[0]
    @user_order =  UserOrder.find_by_id(params[:id])
    @bulk = @user_order.bulk_order
  end

  # GET /user_orders/new
  def new
    @user_order = UserOrder.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # GET /user_orders/1/edit
  def edit
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.where(item_name: params[:item])[0]
    @bulk = @item.bulk_orders.where(completed: false)[0]
  end

  # POST /user_orders
  # POST /user_orders.json
  def create
    # EDIT BULK ORDER INSTEAD
  end

  # PATCH/PUT /user_orders/1
  # PATCH/PUT /user_orders/1.json
  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = @user_order.bulk_order
    @users = @bulk_order.users

    @bulk_order.percent_filled = @bulk_order.percent_filled - (@bulk_order.user_orders.where(id:@user_order.id)[0].quantity)
    @bulk_order.percent_filled = @bulk_order.percent_filled + @user_order.quantity
    @bulk_order.save

    @user_order.quantity = params[:user_order][:quantity]
    @user_order.total_price = @user_order.quantity * params[:price].to_i
    @user_order.save
    
    if @bulk_order.percent_filled >= @bulk_order.max_amount
      @item = @bulk_order.item
      @item.current_amount=@item.current_amount- @item.bulk_order_amount
      @item.save
      @bulk_order.completed = true
      @bulk_order.save
      if @bulk_order.users.count > 1
        @bulk_order.users.each do |user|
          @user_order = @bulk_order.user_orders.where(user_id: user.id)[0]
          NotifMailer.single_order_email(user,@bulk_order,@user_order).deliver
          NotifMailer.vendor_email(@bulk_order).deliver
        end
      else
        NotifMailer.single_order_email(@user,@bulk_order,@user_order).deliver
        NotifMailer.vendor_email(@bulk_order).deliver
      end
    end
    respond_to do |format|
      if @user_order.update(user_order_params)
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user_order.errors, status: :unprocessable_entity }
      end
    end

    charge = Stripe::Charge.retrieve(@user_order.charge_token)
    re = Stripe::Refund.create(
      charge: charge
    )
    charge.save
    @user_order.charge_token = nil
    @user_order.save

    if @bulk_order.completed == true
      @bulk_order.user_orders.each do |order|
        unless order.charge_token.nil?
          charge = Stripe::Charge.retrieve(order.charge_token)
          charge.capture
          end
        end
        @amount = (@user_order.total_price * 100)
        customer = Stripe::Customer.create(
          :email => params[:stripeEmail],
          :source  => params[:stripeToken]
        )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    else
      @amount = (@user_order.total_price * 100)
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :capture => false,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
      @user_order.charge_token = charge.id
      @user_order.save
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message

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
    # Use callbacks to share common setup or constraints between actions.
    def set_user_order
      @user_order = UserOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_order_params
      params.permit(:item, :user_id, :bulk_order_id, :quantity)
    end
end
