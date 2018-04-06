class NotifMailer < ApplicationMailer
  default from: "jesser360@gmail.com"


  def single_order_email(user,bulk_order,user_order)
    @user = user
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @bulk_order.item.user
    mail(to: @user.email, subject: 'Buyer: Bulk Order has Filled!')
  end

  def vendor_email(bulk_order)
    @bulk_order = bulk_order
    @user = @bulk_order.item.user
    @item = @bulk_order.item
    mail(to: @user.email, subject: 'Vendor: Bulk Order has Filled!')
  end

  def welcome_email(email)
    mail(to: email, subject: 'Welcome to C360!')
  end
end
