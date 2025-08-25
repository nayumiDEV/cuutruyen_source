class Api::V2::WebhooksController < Api::V2::BaseController
  def sepay_payment
    if params['code']
      @banking_order = BankingOrder.find_by unique_code: params['code']

      if @banking_order.present?
        @banking_order.update_column :paid_at, Time.now

        Donation.create(
          user: @banking_order.user,
          amount: @banking_order.amount,
          unique_code: @banking_order.unique_code,
          message: @banking_order.message,
          name: @banking_order.name,
          email: @banking_order.email,
          sepay_id: params['id'],
          sepay_reference_code: params['referenceCode']
        )

        ActionCable.server.broadcast(
          "banking_order_status_channel_#{@banking_order.id}",
          { status: @banking_order.paid_at.present? ? :paid : :unpaid }
        )
      end
    end

    head :ok
  end

  def sepay_spend
    transaction_date_str = params['transactionDate']
    transaction_date = Time.strptime(transaction_date_str, "%Y-%m-%d %H:%M:%S").in_time_zone("Asia/Bangkok")

    if params['transferType'] == 'out'
      Donation.create(
        user: nil,
        amount: params['transferAmount'].to_i * -1,
        unique_code: nil,
        message: params['description'],
        name: nil,
        email: nil,
        sepay_id: params['id'],
        sepay_reference_code: params['referenceCode'],
        created_at: transaction_date
      )
    end

    head :ok
  end
end
