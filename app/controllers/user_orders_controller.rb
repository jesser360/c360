class UserOrdersController < ApplicationController
  before_action :set_user_order, only: [:show, :edit, :update, :destroy]

  # GET /user_orders
  # GET /user_orders.json
  def index
    @user_orders = UserOrder.all
  end

  # GET /user_orders/1
  # GET /user_orders/1.json
  def show
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
    @bulk = BulkOrder.where(item: params[:item])[0]
  end

  # POST /user_orders
  # POST /user_orders.json
  def create
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @user_order = UserOrder.new(user_order_params)
    @user_order.quantity = params[:user_order][:quantity]
    @user_order.expiration = 14
    @user_order.total_price = @user_order.quantity * params[:price].to_i
    respond_to do |format|
      if @user_order.save
        format.html { redirect_to user_path_url(@user), notice: 'User order was successfully created.' }
        format.json { render :show, status: :created, location: @user_order }
      else
        format.html { render :new }
        format.json { render json: @user_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_orders/1
  # PATCH/PUT /user_orders/1.json
  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_order = @user_order.bulk_order
    @bulk_order.percent_filled = @bulk_order.percent_filled - (@bulk_order.user_orders.where(id:@user_order.id)[0].quantity)
    @user_order.quantity = params[:user_order][:quantity]
    @user_order.total_price = @user_order.quantity * params[:price].to_i
    @bulk_order.percent_filled = @bulk_order.percent_filled + @user_order.quantity
    @bulk_order.save
    respond_to do |format|
      if @user_order.update(user_order_params)
        format.html { redirect_to user_path_url(@user), notice: 'User order was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_orders/1
  # DELETE /user_orders/1.json
  def destroy
    @user_order.destroy
    respond_to do |format|
      format.html { redirect_to user_orders_url, notice: 'User order was successfully destroyed.' }
      format.json { head :no_content }
    end
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
