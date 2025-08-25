class BankingOrder < ApplicationRecord
  belongs_to :user, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100000000 }
  validates :message, length: { maximum: 1000 }

  def qr_url
    "https://qr.sepay.vn/img?acc=0346515305&bank=MBBank&amount=#{amount.round}&des=#{unique_code}"
  end
end
