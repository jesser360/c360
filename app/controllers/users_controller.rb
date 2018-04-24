class UsersController < ApplicationController

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    @zip = ZipCodes.identify(user_params[:zipcode])
    @user.city = @zip[:city] rescue nil
    @user.state = @zip[:state_name] rescue nil
    if user_params[:supplier_code].present? && user_params[:supplier_code] != '123'
      @code = user_params[:supplier_code]
      if $supplier_hash.has_value?(@code)
        @key =  $supplier_hash.key(@code)
        $supplier_hash.delete(@key)
        if @user.save
          session[:user_id] = @user.id
          redirect_to '/items'
        else
          flash[:error] = @user.errors.full_messages
        end
      else
        flash[:error] = 'Incorrect Supplier Code'
        redirect_to '/signup'
      end
    else
      if @user.save
        session[:user_id] = @user.id
        redirect_to '/items'
      else
        flash[:error] = @user.errors.full_messages
      end
    end

  end

  def show
    @items = Item.all
    @user = User.find_by_id(params[:id])
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user.bulk_orders
    @user_orders = []
    @current_user.user_orders.each do |order|
      @user_orders.push(order.id)
    end

  end

  def edit
  @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    redirect_to user_path_url(@user)
  end


  private
  def user_params
    params.require(:user).permit(:email,:company_name,:password, :password_confirmation, :is_vendor,:zipcode,:supplier_code,:avatar)
  end
end
