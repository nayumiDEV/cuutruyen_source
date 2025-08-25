json.data do
  json.partial! 'api/v2/admin_manage/donations/donation', collection: @donations, as: :donation
end
