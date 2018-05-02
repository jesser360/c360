class OrderItem < ApplicationRecord
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :preserve_files => true
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :bulk_orders
  has_many :user_orders
  belongs_to :user
  belongs_to :item

  def self.create_order_item_from_item(item)
    OrderItem.transaction do
      @order_item = OrderItem.new()
      @order_item.avatar= item.avatar if item.avatar
      @order_item.closed = false
      @order_item.name = item.item_name
      @order_item.user = item.user
      @order_item.price = item.price
      @order_item.market_price = item.market_price
      @order_item.max_amount = item.max_amount
      @order_item.bulk_order_amount = item.bulk_order_amount
      @order_item.current_amount = item.current_amount
      @order_item.avatar_file_name = item.avatar_file_name
      @order_item.avatar_content_type = item.avatar_content_type
      @order_item.avatar_file_size = item.avatar_file_size
      @order_item.avatar_updated_at = item.avatar_updated_at
      @order_item.save
      item.order_items.push(@order_item)
      item.save
      @order_item.save
    end
    return @order_item
  end

end
