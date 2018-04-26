require "open-uri"

class Item < ApplicationRecord
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :preserve_files => true
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :bulk_orders
  has_many :order_items
  belongs_to :user

  def avatar_remote_url=(url_value)
    self.avatar = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # avatar_file_name == "face.png"
    # avatar_content_type == "image/png"
    @avatar_remote_url = url_value
  end

  def picture_from_url(url)
    self.picture = URI.parse(url).open
  end
end
