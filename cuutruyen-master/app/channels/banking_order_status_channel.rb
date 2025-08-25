class BankingOrderStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "banking_order_status_channel_#{params[:banking_order_id]}"
    banking_order = BankingOrder.find(params[:banking_order_id])
    transmit(status: banking_order.paid_at.present? ? :paid : :unpaid)
  end
end
