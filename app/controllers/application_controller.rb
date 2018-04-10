class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  $supplier_hash = {2=>'abc',23=>'def',23=>'ghi'}

end
