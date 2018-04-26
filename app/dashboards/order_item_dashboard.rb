require "administrate/base_dashboard"

class OrderItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    bulk_orders: Field::HasMany,
    user_orders: Field::HasMany,
    user: Field::BelongsTo,
    item: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    price: Field::Number,
    max_amount: Field::Number,
    bulk_order_amount: Field::Number,
    current_amount: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    avatar_file_name: Field::String,
    avatar_content_type: Field::String,
    avatar_file_size: Field::Number,
    avatar_updated_at: Field::DateTime,
    closed: Field::Boolean,
    av: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :bulk_orders,
    :user_orders,
    :user,
    :item,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :bulk_orders,
    :user_orders,
    :user,
    :item,
    :id,
    :name,
    :price,
    :max_amount,
    :bulk_order_amount,
    :current_amount,
    :created_at,
    :updated_at,
    :avatar_file_name,
    :avatar_content_type,
    :avatar_file_size,
    :avatar_updated_at,
    :closed,
    :av,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :bulk_orders,
    :user_orders,
    :user,
    :item,
    :name,
    :price,
    :max_amount,
    :bulk_order_amount,
    :current_amount,
    :avatar_file_name,
    :avatar_content_type,
    :avatar_file_size,
    :avatar_updated_at,
    :closed,
    :av,
  ].freeze

  # Overwrite this method to customize how order items are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(order_item)
  #   "OrderItem ##{order_item.id}"
  # end
end
