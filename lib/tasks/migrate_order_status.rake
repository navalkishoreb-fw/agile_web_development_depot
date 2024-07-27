namespace :migrate do
  desc "Migrate existing orders to have an associated order_status with 'received' and update order_status_id in orders table"
  task migrate_order_status: :environment do
    Order.find_each do |order|
      if order.order_status.nil?
        order_status = OrderStatus.create!(order: order, status: 'received')
        order.update!(order_status_id: order_status.id)
      end
    end
    puts "Migration complete: All existing orders have been updated with an 'order_status' of 'received' and order_status_id set in orders table."
  end
end