require "administrate/base_dashboard"

class ItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    bulk_orders: Field::HasMany,
    user: Field::BelongsTo,
    id: Field::Number,
    item_name: Field::String,
    price: Field::Number,
    image: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    s: Field::String,
    max_amount: Field::Number,
    bulk_order_amount: Field::Number,
    current_amount: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :item_name,
    :user,
    :bulk_orders,
    :price,
    :max_amount,
    :current_amount,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :bulk_orders,
    :user,
    :id,
    :item_name,
    :price,
    :image,
    :created_at,
    :updated_at,
    :s,
    :max_amount,
    :bulk_order_amount,
    :current_amount,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :bulk_orders,
    :user,
    :item_name,
    :price,
    :image,
    :s,
    :max_amount,
    :bulk_order_amount,
    :current_amount,
  ].freeze

  # Overwrite this method to customize how items are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(item)
    item.item_name
  end
end
