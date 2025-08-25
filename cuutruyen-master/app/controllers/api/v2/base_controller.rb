class Api::V2::BaseController < ApplicationController
  include ActionController::Caching

  class NotFoundError < StandardError
    def status_code
      :not_found
    end
  end
  class UnauthorizedError < StandardError
    def status_code
      :unauthorized
    end
  end
  class ForbiddenError < StandardError
    def status_code
      :forbidden
    end
  end
  class UnprocessableEntityError < StandardError
    attr_reader :data

    def initialize(message, data = nil)
      super(message)
      @data = data
    end

    def status_code
      :unprocessable_entity
    end
  end

  rescue_from StandardError, with: :handle_unknown_error
  rescue_from NotFoundError, with: :handle_common_error
  rescue_from UnauthorizedError, with: :handle_common_error
  rescue_from ForbiddenError, with: :handle_common_error
  rescue_from UnprocessableEntityError, with: :handle_common_error

  include Pagy::Backend

  def per_page
    if params[:per_page]
      params[:per_page].to_i.clamp(5, 50)
    else
      20
    end
  end

  def handle_common_error error
    render(
      'api/v2/base/error',
      locals: {
        message: error.message,
        data: error.respond_to?(:data) ? error.data : nil
      },
      status: error.status_code
    )
  end

  def handle_unknown_error error
    if Rails.env.development?
      raise error
    else
      backtrace = error.backtrace || []
      cleaner = ActiveSupport::BacktraceCleaner.new
      cleaner.add_silencer { |line| line =~ /gems/ }
      cleaner.add_silencer { |line| line =~ /lib\/ruby/ }
      relevant_trace = cleaner.clean(backtrace).join(' | ')

      error_message = "#{error.class.name}: #{error.message} | Trace: #{relevant_trace}"
      Rails.logger.error error_message

      render 'api/v2/base/error', locals: { message: 'Lỗi không xác định đã xảy ra, vui lòng thông báo với Cứu Truyện :(' }, status: :internal_server_error
    end
  end
end
