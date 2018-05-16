class BulkOrdersController < ApplicationController
  before_action :set_bulk_order, only: [:show, :edit, :update, :destroy]

  # GET /bulk_orders/1
  # GET /bulk_orders/1.json
  def show
    @bulk_order = BulkOrder.find(params[:id])
    @item = @bulk_order.item
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @seller = @item.user
  end

  def index
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_orders = BulkOrder.all
    @open_bulk_orders = BulkOrder.where(completed: false)
  end
  # GET /bulk_orders/new
  def new
    @item = Item.find_by_id(params[:item].to_i) rescue nil
    @bulk_order = BulkOrder.new
    # @user_order = UserOrder.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # GET /bulk_orders/1/edit
  def edit
    @bulk = BulkOrder.find_by_id(params[:id])
    @item = Item.find_by_id(params[:item])
    @seller = @item.user
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end


  # SUPPLIER STARTING NEW BATCH
  def create
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find_by_id(params[:bulk_order][:item])
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

  # PATCH/PUT /bulk_orders/1
  # PATCH/PUT /bulk_orders/1.json
  # User adding to an exisiting bulk order for their first time
  def update
    @bulk_order = BulkOrder.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @users = @bulk_order.users
    @user_order = UserOrder.new()
    @item = @bulk_order.item

    @user_order = UserOrder.create_user_order(params[:bulk_order],@user,@bulk_order)

    @bulk_order.users.push(@user)
    @bulk_order.user_orders.push(@user_order)
    @bulk_order.percent_filled = (@bulk_order.percent_filled +  params[:bulk_order][:quantity].to_i)

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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_order
      @bulk_order = BulkOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_order_params
      params.require(:bulk_order).permit(:percent_filled, :expiration, :item,:quantity, :market_price,:wholesale_price)
    end
end
