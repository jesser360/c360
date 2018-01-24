class BulkOrdersController < ApplicationController
  before_action :set_bulk_order, only: [:show, :edit, :update, :destroy]

  # GET /bulk_orders
  # GET /bulk_orders.json
  def index
    @bulk_orders = BulkOrder.all
  end

  # GET /bulk_orders/1
  # GET /bulk_orders/1.json
  def show
  end

  # GET /bulk_orders/new
  def new
    @item = Item.where(item_name: params[:item])[0]
    @bulk_order = BulkOrder.new
    @user_order = UserOrder.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # GET /bulk_orders/1/edit
  def edit
    @bulk = BulkOrder.find_by_id(params[:id]) 
    @item = Item.where(item_name: params[:item])[0]
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # POST /bulk_orders
  # POST /bulk_orders.json
  def create
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = BulkOrder.new()
    @user_order = UserOrder.new()
    @date = Date.today
    @end_date= (@date+15).to_s
    @bulk_order.expire_date = @end_date
    @user_order.quantity = params[:bulk_order][:quantity]
    @user_order.item = params[:item]
    @user_order.user= @user
    @user_order.total_price = @user_order.quantity * params[:price].to_i
    @user_order.save
    @bulk_order.user_orders.push(@user_order)
    @bulk_order.users.push(@user)
    @bulk_order.max_amount=100
    @bulk_order.item = params[:item]
    @bulk_order.percent_filled = (@bulk_order.percent_filled || 0 + @user_order.quantity)
    respond_to do |format|
      if @bulk_order.save
        puts 'bulk SAVED'
        puts @bulk_order.expire_date
        format.html { redirect_to user_path_url(@user), notice: 'Bulk order was successfully created.' }
        format.json { render :show, status: :created, location: @bulk_order }
      else
        format.html { render :new }
        format.json { render json: @bulk_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_orders/1
  # PATCH/PUT /bulk_orders/1.json
  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @user_order = UserOrder.new()
    @user_order.expiration = 14
    @user_order.quantity = params[:bulk_order][:quantity]
    @user_order.item = params[:item]
    @user_order.total_price = @user_order.quantity * params[:price].to_i
    @user_order.user= @user
    @user_order.save
    @bulk_order.users.push(@user)
    @bulk_order.user_orders.push(@user_order)
    @bulk_order.percent_filled = (@bulk_order.percent_filled +  params[:bulk_order][:quantity].to_i)
    respond_to do |format|
      if @bulk_order.save
        format.html { redirect_to user_path_url(@user), notice: 'You were added to this BUlk Order.' }
        format.json { render :show, status: :ok, location: @bulk_order }
      else
        format.html { render :edit }
        format.json { render json: @bulk_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_orders/1
  # DELETE /bulk_orders/1.json
  def destroy
    @bulk_order.destroy
    respond_to do |format|
      format.html { redirect_to bulk_orders_url, notice: 'Bulk order was successfully destroyed.' }
      format.json { head :no_content }
    end
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
