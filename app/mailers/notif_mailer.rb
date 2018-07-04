class NotifMailer < ApplicationMailer
  default from: "c360@gmail.com"


  def registration_confirmation(user)
     @user = user
     mail(:to => @user.email, :subject => "Registration Confirmation")
  end

  def single_order_email(bulk_order,user_order)
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @item.user
    @user = @user_order.user
    if @user
      mail(to: @user.email, subject: 'Buyer: Your Bulk Order has Filled!')
    else
      mail(to: @user_order.buyer_email, subject: 'Buyer: Your Bulk Order has Filled!')
    end
  end

  def no_user_single_order_email(bulk_order,user_order)
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @item.user
    @buyer_email = @user_order.buyer_email
    mail(to: @buyer_email, subject: 'Buyer: Your Private Guest Order has Filled!')
  end

  def no_user_bulk_order_email(bulk_order,user_order)
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @item.user
    @buyer_email = @user_order.buyer_email
    mail(to: @buyer_email, subject: 'Buyer: You have Joined a Bulk Order as a Guest!')
  end

  def bulk_fill_buyer_email(bulk_order,user_order)
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @item.user
    if @user_order.user
      mail(to: @user_order.user.email, subject: 'Buyer: Your Bulk Order has filled!')
    else
      mail(to: @user_order.buyer_email, subject: 'Buyer: Your guest Bulk Order has filled!')
    end
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
