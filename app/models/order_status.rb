class OrderStatus < ApplicationRecord
  belongs_to :order
  enum status: { received: 'received', shipped: 'shipped' }
  after_create :update_order_with_order_status_send_confirmation_email_and_schedule_shipped_email
  after_update_commit :send_shipped_email, if: :shipped_status?
  after_update_commit :send_received_email, if: :received_status?

  private def update_order_with_order_status_send_confirmation_email_and_schedule_shipped_email
    order.update(order_status_id: self.id)
    logger.info("after_create: update_order_with_order_status_send_confirmation_email_and_schedule_shipped_email: #{order.id}")
    OrderMailer.received(order).deliver_later
    OrderStatusUpdaterJob.set(wait: 60.seconds).perform_later(order.id)
  end

  private def received_status?
    logger.info("after_update_commit: received_status?: #{order.id}")
    order.order_status.status == 'received'
  end

  def send_received_email
    logger.info("after_update_commit: enqueue_status_update: #{order.id}")
    OrderMailer.received(order).deliver_later
  end

  private def shipped_status?
    logger.info("after_update_commit: shipped_status?: #{order.id}")
    order.order_status.status == 'shipped'
  end

  def send_shipped_email
    logger.info("after_update_commit: send_shipped_email: #{order.id}")
    OrderMailer.shipped(order).deliver_later
  end
end
