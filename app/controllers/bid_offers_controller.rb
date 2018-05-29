class BidOffersController < ApplicationController

  def new
    @bid_offer = BidOffer.new()
    @bid = Bid.find(params[:bid_id])
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def create
    @bid_offer = BidOffer.new(bid_offer_params)
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bid_offer.user = @user
    @bid = Bid.find(params[:bid_id])
    @bid_offer.bid = @bid
    respond_to do |format|
      if @bid_offer.save
        format.html { redirect_to user_supplier_path_url(@user)}
        format.json { render :show, status: :created, location: @bid_offer }
      else
        puts @bid_offer.errors.messages
        format.html { redirect_to user_path_url(@user)}
        format.json { render json: @bid_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @bid_offer = BidOffer.find_by_id(params[:id])
    @bid = @bid_offer.bid
    @user = User.find_by_id(session[:user_id]) if session[:user_id]

    respond_to do |format|
     format.html
     format.pdf {
       generate_pdf("show")
     }
    end
  end

  def index
    @bid = Bid.find_by_id(params[:bid_id])
    @bid_offers = @bid.bid_offers
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end


  private

  def generate_pdf(view_page)
    html = render_to_string(:action => "#{view_page}", :formats => [:html], :layout => false, :locals => {:pdf => true})
    pdf = HtmlToPdfService.convert(html, :static_url => "http://localhost:3000")
    options = {
      :disposition => "attachment",
      :filename => "#{view_page}-#{Time.now.strftime('%m%d%Y')}.pdf",
      :type => "application/pdf"
    }
    send_data(pdf, options)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @bid_offer = BidOffer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bid_offer_params
      params.require(:bid_offer).permit(:delivery_date, :price,:notes)
    end

end
