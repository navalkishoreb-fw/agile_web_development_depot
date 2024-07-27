class OrderStatus < ApplicationRecord
  belongs_to :order
  enum status: { received: 'received', shipped: 'shipped' }
  after_create :update_order_with_order_status

  private def update_order_with_order_status
    order.update(order_status_id: self.id)
  end
end
