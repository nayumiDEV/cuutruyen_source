class Donation < ApplicationRecord
  belongs_to :user, optional: true
end
