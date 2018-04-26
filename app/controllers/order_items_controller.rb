class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]


  # GET /OrderItems
  # GET /OrderItems.json
  def index
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @OrderItems = OrderItem.all
  end

  # GET /OrderItems/new
  def new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @OrderItem = OrderItem.new
  end

  # GET /OrderItems/1/edit
  def edit
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @OrderItem = OrderItem.find_by_id(params[:id])
  end

  # POST /OrderItems
  # POST /OrderItems.json
  def create
    @OrderItem = OrderItem.new(OrderItem_params)
    @user = User.find_by_id(session[:user_id]) if session[:user_id]

    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @OrderItem.user = @user #This is the owner of the OrderItem
    respond_to do |format|
      if @OrderItem.save
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :created, location: @OrderItem }
      else
        format.html { render :new }
        format.json { render json: @OrderItem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /OrderItems/1
  # PATCH/PUT /OrderItems/1.json
  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @OrderItem = OrderItem.find(params[:id])
    respond_to do |format|
      if @OrderItem.update(OrderItem_params)
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :ok, location: @OrderItem }
      else
        format.html { render :edit }
        format.json { render json: @OrderItem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /OrderItems/1
  # DELETE /OrderItems/1.json
  def destroy
    @OrderItem.destroy
    respond_to do |format|
      format.html { redirect_to OrderItems_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_OrderItem
      @OrderItem = OrderItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def OrderItem_params
      params.require(:order_item).permit(:name, :price, :image,:max_amount,:bulk_order_amount,:avatar,:current_amount,:closed)
    end
end
