class UsersController < ApplicationController

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    @user.email_confirmed = false
    @user.email_confirm_token = SecureRandom.urlsafe_base64.to_s
    @zip = ZipCodes.identify(user_params[:zipcode])
    @user.city = @zip[:city] rescue nil
    @user.state = @zip[:state_name] rescue nil
    if user_params[:supplier_code].present? && user_params[:supplier_code] != '123'
      @code = user_params[:supplier_code]
      if $supplier_hash.has_value?(@code)
        @key =  $supplier_hash.key(@code)
        $supplier_hash.delete(@key)
        if @user.save
          # session[:user_id] = @user.id
          # if @user.is_vendor
          #   redirect_to user_supplier_path_url(@user)
          # else
          #   redirect_to user_path_url(@user)
          # end
          NotifMailer.registration_confirmation(@user).deliver
          flash[:success] = "Please confirm your email now"
          redirect_to root_url
        else
          flash[:error] = @user.errors.full_messages
        end
      else
        flash[:error] = 'Incorrect Supplier Code'
        redirect_to '/signup'
      end
    else
      if @user.save
        NotifMailer.registration_confirmation(@user).deliver
        flash[:success] = "Please confirm your email address to continue"
        redirect_to root_url
        # if @user.is_vendor
        #   redirect_to user_supplier_path_url(@user)
        # else
        #   redirect_to user_path_url(@user)
        # end
      else
        flash[:error] = @user.errors.full_messages
      end
    end

  end

  def confirm_email
      @user = User.find_by_email_confirm_token(params[:id])
      if @user
        @user.email_confirmed = true
        @user.email_confirm_token = nil
        @user.save!(:validate => false)
        flash[:success] = "Welcome to C360 Supply! Your email has been confirmed.
        Please sign in to continue."
        redirect_to '/login'
      else
        flash[:error] = "Sorry. User does not exist"
        redirect_to root_url
      end
  end

  def show
    @items = Item.all
    @user = User.find_by_token(params[:id])
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user.bulk_orders
    @reviews = Review.where(user: @user)

    @user_bids_buyer_queued = Bid.where(buyer_id:@user.id).where(supplier_id:nil).where(published: false)
    @user_bids_buyer_open = Bid.where(buyer_id:@user.id).where(supplier_id:nil)
    @user_bids_buyer_closed = Bid.where(buyer_id:@user.id).where.not(supplier_id:nil)

    @open_orders = []
    @closed_orders = []
    @expired_orders = []
    # @open_orders_duplicates_ids = []
    @user.user_orders.each do |order|
      if order.bulk_order.completed || order.buy_now
        @closed_orders.push(order)
      elsif Date.today > order.bulk_order.expire_date
        @expired_orders.push(order)
      else
        @open_orders.push(order)
        # @open_orders_duplicates.push(order.bulk_order.id)
        # if order.bulk_order @open_orders_duplicates_ids.find_all { |e| @open_orders_duplicates.count(e) > 1 }
        # puts'duplicate'
        # puts order.id
      end
    end


  end

  def show_supplier
    @user = User.find_by_token(params[:token])
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]

    @open_orders = []
    @closed_orders = []
    @expired_orders = []
    @queued_orders = []
    @user.items.each do |item|
      item.bulk_orders.each do |bulk_order|
        if bulk_order.published != true
          @queued_orders.push(bulk_order)
        elsif Date.today > bulk_order.expire_date
          @expired_orders.push(bulk_order)
        elsif bulk_order.completed == false
          @open_orders.push(bulk_order)
        else
          @closed_orders.push(bulk_order)
        end
      end
    end
    @open_bids = Bid.where(supplier_id:nil)
    @user_bids_new = []
    @user_bids_offered = []
    @open_bids.each do |bid|
      if bid.bid_offers.where(user_id: @user.id).present?
        @user_bids_offered.push(bid)
      else
        @user_bids_new.push(bid)
      end
    end
    @user_bids_supplier = Bid.where(supplier_id:@user.id)
  end

  def edit
    @user = User.find_by_token(params[:token])
  end

  def update
    @user = User.find_by_token(params[:token])
    @user.update(user_params)
    @zip = ZipCodes.identify(user_params[:zipcode])
    @user.city = @zip[:city] rescue nil
    @user.state = @zip[:state_name] rescue nil
    @user.save
    if @user.is_vendor
      redirect_to user_supplier_path_url(@user)
    else
      redirect_to user_path_url(@user)
    end
  end



  private

  def set_user
    @user = User.find_by_token(params[:id])
  end

  def user_params
    params.require(:user).permit(:email,:company_name,:password, :password_confirmation, :is_vendor,:zipcode,:supplier_code,:avatar)
  end
end
