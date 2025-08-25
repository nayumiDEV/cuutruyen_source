ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |name, start, finish, request_id, payload|
  request = payload[:request]
  client_header = request.env['HTTP_CUUTRUYEN_CLIENT'] if request
  Rails.logger.warn "Rack attack throttled: #{request&.remote_ip}, path: #{request&.path}, client: #{client_header}"
end
