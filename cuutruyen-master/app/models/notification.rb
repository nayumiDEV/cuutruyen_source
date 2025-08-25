class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  def params
    return self[:params] if self[:params].class == Hash
    JSON.parse(self[:params]).transform_keys(&:to_sym)
  end
end
