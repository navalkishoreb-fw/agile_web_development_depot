class OrderMailer < ApplicationMailer

  default from: "Sam Ruby <depot@example.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order
    mail to: order.email, subject: "Pragmatic Store Order Confirmation (##{@order.id})"
    logger.info("OrderMailer:received #{order.id}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order
    mail to: order.email, subject: "Pragmatic Store Order Shipped (##{@order.id})"
    logger.info("OrderMailer:shipped #{order.id}")
  end
end
