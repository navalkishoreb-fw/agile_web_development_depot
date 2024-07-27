namespace :rollback do
  desc "Rollback the migration that added 'received' order statuses to existing orders and clear order_status_id in orders table"
  task rollback_migrate_order_status: :environment do
    OrderStatus.where(status: 'received').each do |order_status|
      if order_status.order.present?
        order_status.order.update!(order_status_id: nil)
        order_status.destroy
      end
    end
    puts "Rollback complete: 'received' order statuses have been removed from existing orders and order_status_id cleared in orders table."
  end
end