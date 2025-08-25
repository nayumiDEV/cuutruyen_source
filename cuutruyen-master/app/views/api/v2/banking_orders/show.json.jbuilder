json.data do
  json.id @banking_order.id
  json.amount @banking_order.amount
  json.valid_until @banking_order.valid_until
  json.paid_at @banking_order.paid_at
  json.unique_code @banking_order.unique_code
  json.message @banking_order.message
  json.qr_url @banking_order.qr_url

  if @banking_order.user.present?
    json.user do
      json.id @banking_order.user.id
      json.username @banking_order.user.username
    end
  end
end
