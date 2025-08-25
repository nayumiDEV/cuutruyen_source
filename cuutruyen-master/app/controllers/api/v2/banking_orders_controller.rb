class Api::V2::BankingOrdersController < Api::V2::BaseController

  def show
    @banking_order = BankingOrder.find(params[:id])
  end

  def create
    @banking_order = BankingOrder.new banking_order_params
    @banking_order.valid_until = Time.now + 1.day
    @banking_order.unique_code = "CUUTR#{SecureRandom.random_number(10**16).to_s.rjust(16, '0')}"

    if @banking_order.save
      render :show, status: :accepted
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @banking_order.errors)
    end
  end

  private

  def banking_order_params
    params.require(:banking_order).permit(:user_id, :amount, :message)
  end
end
