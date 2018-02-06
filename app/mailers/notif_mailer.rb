class NotifMailer < ApplicationMailer
  default from: "jesser360@gmail.com"


  def sample_email(user,bulk_order,user_order)
  @user = user
  @bulk_order = bulk_order
  @user_order = user_order
  @item = @bulk_order.item
  @vendor = @bulk_order.item.user
  mail(to: @user.email, subject: 'Bulk Order has Filled!')
  end

end
