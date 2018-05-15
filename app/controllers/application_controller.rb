class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  $supplier_hash = {2=>'abc',23=>'def',23=>'ghi'}

  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end

  helper_method :current_user
end
