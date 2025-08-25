json.data do
  json.partial! 'api/v2/donations/donation', collection: @donations, as: :donation
end

json._metadata do
  json.all_time_total @all_time_total
end
