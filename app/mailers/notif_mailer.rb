class NotifMailer < ApplicationMailer
  default from: "c360@gmail.com"


  def registration_confirmation(user)
     @user = user
     mail(:to => @user.email, :subject => "Registration Confirmation")
  end

  def single_order_email(user,bulk_order,user_order)
    @user = user
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @item.user
    mail(to: @user.email, subject: 'Buyer: Bulk Order has Filled!')
  end

  def vendor_email(bulk_order)
    @bulk_order = bulk_order
    @user = @bulk_order.item.user
    @item = @bulk_order.item
    mail(to: @user.email, subject: 'Supplier: Bulk Order has Filled!')
  end

  def vendor_buy_now_email(user,user_order,item)
    @user_order = user_order
    @item = item
    mail(to: user.email, subject: 'Supplier: Buy Now Order has Filled!')
  end

  def welcome_email(email)
    mail(to: email, subject: 'Welcome to C360!')
  end
end
