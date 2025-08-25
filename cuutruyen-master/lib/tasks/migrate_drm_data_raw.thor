require 'thor'
require File.expand_path('config/environment.rb')

class MigrateDrmDataRaw < Thor
  desc "start", "TODO"
  def start
    Page.find_each do |page|
      drm_data = page.drm_data
      drm_data_bin = Base64.decode64(drm_data)
      reverse_xored = Xorob::xor_string(drm_data_bin, (Math::PI * (10**15)).round.to_s)
      page.update_column :drm_data_raw, reverse_xored
      puts page.id if page.id % 300 == 0
    end
  end
end
