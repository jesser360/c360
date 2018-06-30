class BulkOrdersController < ApplicationController
  before_action :set_bulk_order, only: [:show, :edit, :update, :destroy]
  before_action :auth, only: [:show, :edit, :update, :destroy]

  def auth
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    if @user.nil?
      redirect_to '/login'
    end
  end

  # GET /bulk_orders/1
  # GET /bulk_orders/1.json
  def show
    @bulk_order = BulkOrder.find(params[:id])
    @item = @bulk_order.item
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @seller = @item.user
    @reviews = Review.where(item: @item)
  end

  def index
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_orders = BulkOrder.all
    @open_bulk_orders = BulkOrder.where(completed: false).where(published: true).where(['expire_date > ?', DateTime.now])
  end

  # GET /bulk_orders/new
  def new
    @item = Item.find_by_id(params[:item].to_i) rescue nil
    @bulk_order = BulkOrder.new()
    @bulk_order.market_price = params[:market_pr]
    @bulk_order.wholesale_price = params[:whole_pr]
    @bulk_order.max_amount = params[:amount]
    @bulk_order.item = Item.find_by_id(params[:item])

    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end


  # SUPPLIER STARTING NEW BATCH
  def create
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find_by_id(params[:item])
    @bulk_order = BulkOrder.create_bulk_order(@item,params[:bulk_order])

    respond_to do |format|
      if @bulk_order.save
        format.html { redirect_to user_supplier_path_url(@user) }
        format.json { render :show, status: :created, location: @bulk_order }
      else
        format.html { render :new }
        format.json { render json: @bulk_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /bulk_orders/1/edit
  def edit
    @bulk = BulkOrder.find_by_id(params[:id])
    @item = @bulk.item
    @seller = @item.user
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @reviews = Review.where(item: @item)
  end

  def seller_edit
    @bulk_order = BulkOrder.find_by_id(params[:id])
    @item = Item.find_by_id(params[:item])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # PATCH/PUT /bulk_orders/1
  # PATCH/PUT /bulk_orders/1.json
  # User adding to an exisiting bulk order for their first time
  def update
    @bulk_order = BulkOrder.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @users = @bulk_order.users
    @item = @bulk_order.item

    if params[:bulk_order][:quantity]
      @user_order = UserOrder.new()
      @user_order = UserOrder.create_user_order(params[:bulk_order],@user,@bulk_order)

      @shipping_address = Address.create_shipping_address(params,@user_order)
      @billing_address = Address.create_billing_address(params,@user_order)

      @bulk_order.users.push(@user)
      @bulk_order.user_orders.push(@user_order)
      @bulk_order.percent_filled = (@bulk_order.percent_filled +  params[:bulk_order][:quantity].to_i)
      @bulk_order.buyer_count +=1

      if @bulk_order.percent_filled >= @bulk_order.max_amount
        @bulk_order.completed = true
        BulkOrder.email_bulk_order_users(@bulk_order,@user,@user_order)
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

    StripeService::update_bulk_order_payment(params,@user_order,@bulk_order)

    else #IF USER IS EDITING BATCH BEFORE PUBLISH
      @bulk_order.update(bulk_order_params)
      @bulk_order.save
      redirect_to user_supplier_path_url(@user)

    end
  end


  def publish
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = BulkOrder.find_by_id(params[:id])
    @bulk_order.published = true
    @bulk_order.save
    redirect_to user_supplier_path_url(@current_user)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_order
      @bulk_order = BulkOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_order_params
      params.require(:bulk_order).permit(:max_amount, :percent_filled, :expiration, :item,:quantity, :market_price,:wholesale_price)
    end
end
