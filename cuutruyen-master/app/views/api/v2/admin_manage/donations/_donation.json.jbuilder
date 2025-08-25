json.id donation.id
json.unique_code donation.unique_code
json.amount donation.amount
json.message donation.message
if donation.user.present?
  json.user do
    json.id donation.user.id
    json.username donation.user.username
  end
end
json.sepay_id donation.sepay_id
json.sepay_reference_code donation.sepay_reference_code
json.created_at donation.created_at
