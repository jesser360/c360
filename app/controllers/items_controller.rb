class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :auth

  def auth
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    if @user.nil?
      redirect_to '/login'
    end
  end

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk_orders = BulkOrder.all
    @bulk_order_items = []
    @bulk_orders.each do |bulk|
      @bulk_order_items.push(bulk.item)
    end
  end

  # GET /items/new
  def new
    @item = Item.new
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # GET /items/1/edit
  def edit
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @user = User.find_by_id(session[:user_id]) if session[:user_id]

    @item.current_amount = item_params[:max_amount]
    @item.user = @user #This is the owner of the item
    respond_to do |format|
      if @item.save
        format.html { redirect_to user_supplier_path_url(@user)}
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find(params[:id])
    @item.current_amount = item_params[:max_amount]
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to user_supplier_path_url(@user)}
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:item_name, :price,:market_price, :image,:max_amount,:bulk_order_amount,:avatar)
    end
end
