class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      if @user.is_vendor
        redirect_to user_supplier_path_url(@user)
      else
        redirect_to user_path_url(@user)
      end
    else
      flash[:error]= "Incorrect Info"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

end
