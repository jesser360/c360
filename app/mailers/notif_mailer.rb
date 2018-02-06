class NotifMailer < ApplicationMailer
  default from: "jesser360@gmail.com"


  def bulk_order_email(users,bulk_order)
    @users = users
      @users.each do |user|
        @user = user
        @bulk_order = bulk_order
        @user_order = @bulk_order.user_orders.where(user_id: user.id)[0]
        @item = @bulk_order.item
        @vendor = @bulk_order.item.user
        mail(to: user.email, subject: 'Bulk Order has Filled!')
        puts "SENT A MAIL RIGHT HEREEEE"
      end
  end

  def single_order_email(user,bulk_order,user_order)
    @user = user
    @bulk_order = bulk_order
    @user_order = user_order
    @item = @bulk_order.item
    @vendor = @bulk_order.item.user
    mail(to: @user.email, subject: 'Bulk Order has Filled!')
  end

end
