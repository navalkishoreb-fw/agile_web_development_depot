class OrderStatusUpdaterJob < ApplicationJob
  queue_as :status_updater

  def perform(order_id)
    order = Order.find(order_id)
    #  Don't do anything if state is already shipped
    return if order.order_status.status == 'shipped'
    logger.info("perform: status update to shipped: #{order.id}")
    order.order_status.update(status: 'shipped')
  end
end