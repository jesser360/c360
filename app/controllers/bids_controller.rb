class BidsController < ApplicationController

  def new
    @bid = Bid.new()
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def create
    @bid = Bid.new(bid_params)
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bid.supplier = nil
    @bid.buyer = @user
    respond_to do |format|
      if @bid.save
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @bid = Bid.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def update
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bid = Bid.find(params[:id])
    @supplier = User.find_by_id(finalize_bid_params[:supplier_id])
    @bid.supplier =  @supplier
    @bid.bid_offers.each do |offer|
      offer.delete unless offer.user.id.to_i == finalize_bid_params[:supplier_id].to_i
    end
    @bid.final_price == @bid.bid_offers[0].price
    respond_to do |format|
      if @bid.save
        format.html { redirect_to user_path_url(@user)}
        format.json { render :show, status: :ok, location: @bid }
      else
        format.html { render :edit }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @bid = Bid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bid_params
      params.require(:bid).permit(:title, :amount,:price_min, :price_max)
    end
    def finalize_bid_params
      params.permit(:supplier_id)
    end

end
