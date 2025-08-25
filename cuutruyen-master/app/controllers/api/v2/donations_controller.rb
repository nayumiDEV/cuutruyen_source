class Api::V2::DonationsController < Api::V2::BaseController
  def index
    year = params[:year] || Time.current.year
    month = params[:month] || Time.current.month

    @donations = Donation.where(
      "EXTRACT(YEAR FROM created_at) = ? AND EXTRACT(MONTH FROM created_at) = ?",
      year, month
    ).order(created_at: :desc)

    @all_time_total = Donation.sum(:amount)
  end
end
