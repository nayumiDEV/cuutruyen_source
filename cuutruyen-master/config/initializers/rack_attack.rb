class Rack::Attack
  class Request < ::Rack::Request
    def remote_ip
      @remote_ip ||= (env['action_dispatch.remote_ip'] || ip).to_s
    end
  end

  # Whitelist upload endpoints
  safelist('allow-upload-endpoints') do |req|
    req.path.start_with?('/api/v2/upload/') || req.path.start_with?('/api/v1/upload/')
  end

  # Rate limit all other requests with different limits based on client header
  throttle('req/ip', limit: ->(req) { req.env['HTTP_CUUTRUYEN_CLIENT'] == 'OfficialWebApp-20250805' ? 100 : 20 }, period: 5.seconds) do |req|
    req.remote_ip
  end
end
