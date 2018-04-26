class AddAttachmentAvatarToOrderItems < ActiveRecord::Migration[5.1]
  def self.up
    change_table :order_items do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :order_items, :avatar
  end
end
