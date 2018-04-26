class BulkOrdersController < ApplicationController
  before_action :set_bulk_order, only: [:show, :edit, :update, :destroy]

  # GET /bulk_orders/1
  # GET /bulk_orders/1.json
  def show
    @bulk_order = BulkOrder.find(params[:id])
    @order_item = @bulk_order.order_item
    @item = @bulk_order.item
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @seller = @order_item.user
  end

  # GET /bulk_orders/new
  def new
    @item = Item.find_by_id(params[:item].to_i) rescue nil
    @bulk_order = BulkOrder.new
    @user_order = UserOrder.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # GET /bulk_orders/1/edit
  def edit
    @bulk = BulkOrder.find_by_id(params[:id])
    @order_item = @bulk.order_item
    @item = Item.find_by_id(params[:item])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # POST /bulk_orders
  # POST /bulk_orders.json
  def create
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find_by_id(params[:item])
    @bulk_order = BulkOrder.new()
    @user_order = UserOrder.new()
    @order_item = OrderItem.new()
    @date = Date.today

    @order_item.avatar= @item.avatar
    @order_item.closed = false
    @order_item.name = @item.item_name
    @order_item.user = @item.user
    @order_item.price = @item.price
    @order_item.max_amount = @item.max_amount
    @order_item.bulk_order_amount = @item.bulk_order_amount
    @order_item.current_amount = @item.current_amount
    @order_item.avatar_file_name = @item.avatar_file_name
    @order_item.avatar_content_type = @item.avatar_content_type
    @order_item.avatar_file_size = @item.avatar_file_size
    @order_item.avatar_updated_at = @item.avatar_updated_at
    @order_item.save

    @item.order_items.push(@order_item)

    @user_order.quantity = params[:bulk_order][:quantity]
    @user_order.user= @user
    @user_order.total_price = @user_order.quantity * @order_item.price
    @user_order.order_item = @order_item
    @user_order.save

    @bulk_order.item = @item
    @bulk_order.order_item = @order_item
    @end_date= (@date+(rand(1..10))).to_s
    @bulk_order.expire_date = @end_date
    @bulk_order.user_orders.push(@user_order)
    @bulk_order.users.push(@user)
    @bulk_order.max_amount= @item.bulk_order_amount
    @bulk_order.completed = false
    @bulk_order.percent_filled = (@bulk_order.percent_filled || 0 + @user_order.quantity)

    # If order fills..
    if @bulk_order.percent_filled >= @bulk_order.max_amount
      # Lowers inventory count for item
      @item.current_amount = (@item.current_amount - @item.bulk_order_amount)
      @item.save

      @order_item.current_amount = @item.current_amount
      @order_item.closed = true
      @order_item.save
      @bulk_order.completed = true
      @bulk_order.save
      NotifMailer.single_order_email(@user,@bulk_order,@user_order).deliver
      NotifMailer.vendor_email(@bulk_order).deliver
    end
    respond_to do |format|
      if @bulk_order.save
        format.html { redirect_to user_path_url(@user) }
        format.json { render :show, status: :created, location: @bulk_order }
      else
        format.html { render :new }
        format.json { render json: @bulk_order.errors, status: :unprocessable_entity }
      end
    end

    @amount = params[:amount]
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
    if @bulk_order.percent_filled >= @bulk_order.max_amount
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    else
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

  # PATCH/PUT /bulk_orders/1
  # PATCH/PUT /bulk_orders/1.json
  # User adding to an exisiting bulk order
  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @users = @bulk_order.users
    @user_order = UserOrder.new()
    @order_item = @bulk_order.order_item
    @item = @bulk_order.item

    @user_order.order_item = @order_item
    @user_order.quantity = params[:bulk_order][:quantity]
    @user_order.total_price = @user_order.quantity * @order_item.price
    @user_order.user= @user
    @user_order.save

    @bulk_order.users.push(@user)
    @bulk_order.user_orders.push(@user_order)
    @bulk_order.percent_filled = (@bulk_order.percent_filled +  params[:bulk_order][:quantity].to_i)

    if @bulk_order.percent_filled >= @bulk_order.max_amount
      @item.current_amount=(@item.current_amount - @item.bulk_order_amount)
      @item.save

      @order_item.current_amount = @item.current_amount
      @order_item.closed = true
      @order_item.save
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
      if @bulk_order.save
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :ok, location: @bulk_order }
      else
        format.html { render :edit }
        format.json { render json: @bulk_order.errors, status: :unprocessable_entity }
      end
    end
    # Capture payments of all other users in bulk order
    if @bulk_order.completed == true
      @bulk_order.user_orders.each do |order|
        if order.charge_token
        charge = Stripe::Charge.retrieve(order.charge_token)
        charge.capture
        end
      end
      # charge this user
      @amount = params[:amount]
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
      @amount = params[:amount]
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_order
      @bulk_order = BulkOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_order_params
      params.require(:bulk_order).permit(:percent_filled, :expiration, :item,:quantity)
    end
end
