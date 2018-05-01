class NotifMailer < ApplicationMailer
  default from: "jesser360@gmail.com"


  def single_order_email(user,bulk_order,user_order)
    @user = user
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @user_order.order_item
    @vendor = @item.user
    mail(to: @user.email, subject: 'Buyer: Bulk Order has Filled!')
  end

  def vendor_email(bulk_order)
    @bulk_order = bulk_order
    @user = @bulk_order.item.user
    @item = @bulk_order.item
    mail(to: @user.email, subject: 'Supplier: Bulk Order has Filled!')
  end
  def vendor_buy_now_email(user_order)
    @user_order = user_order
    @user = @user_order.order_item.user
    @item = @user_order.order_item
    mail(to: @user.email, subject: 'Supplier: Buy Now Order has Filled!')
  end

  def welcome_email(email)
    mail(to: email, subject: 'Welcome to C360!')
  end
end
