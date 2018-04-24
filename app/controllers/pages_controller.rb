class PagesController < ApplicationController
  def home
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def about
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def services
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def construction
    render layout: "empty"
  end
end
