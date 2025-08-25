json.id donation.id
json.amount donation.amount
json.message donation.message
if donation.user.present?
  json.user do
    json.id donation.user.id
    json.username donation.user.username
  end
end
json.created_at donation.created_at
