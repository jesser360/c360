class AddAttachmentAvatarToItems < ActiveRecord::Migration[5.1]
  def self.up
    change_table :items do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :items, :avatar
  end
end
