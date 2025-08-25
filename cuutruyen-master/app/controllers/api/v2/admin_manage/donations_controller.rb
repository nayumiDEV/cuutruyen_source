class Api::V2::AdminManage::DonationsController < Api::V2::AdminManage::BaseController
  def index
    year = params[:year] || Time.current.year
    month = params[:month] || Time.current.month

    @donations = Donation.where(
      "EXTRACT(YEAR FROM created_at) = ? AND EXTRACT(MONTH FROM created_at) = ?",
      year, month
    ).order(created_at: :desc)

    @all_time_total = Donation.sum(:amount)
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def update
    @donation = Donation.find(params[:id])
    @donation.update(donation_params)
  end

  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy
  end

  private

  def donation_params
    params.require(:donation).permit(:name, :email, :amount, :message, :sepay_id, :sepay_reference_code, :user_id, :created_at)
  end
end
