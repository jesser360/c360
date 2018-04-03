class UsersController < ApplicationController

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/items'
    else
      flash[:error] = @user.errors.full_messages
    end
  end

  def show
    @items = Item.all
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @bulk = @user.bulk_orders
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
    params.require(:user).permit(:email,:company_name,:password, :password_confirmation, :is_vendor,:zipcode)
  end
end
