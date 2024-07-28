class Order < ApplicationRecord
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys
  has_many :line_items, dependent: :destroy
  has_one :order_status, dependent: :destroy
  accepts_nested_attributes_for :order_status
  after_create :set_initial_status
  before_destroy :check_order_status_presence

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
      puts item.to_json
    end
  end

  private def set_initial_status
    logger.info("after_create: set_initial_status : create_order_status #{id}")
    create_order_status(status: 'received')
  end

  def check_order_status_presence
    if order_status.present?
      errors.add(:base, "Cannot delete order because an order status is present.")
      throw(:abort)
    end
  end
end
