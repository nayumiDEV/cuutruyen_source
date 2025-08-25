require 'thor'
require File.expand_path('config/environment.rb')

class InitTeamSlug < Thor
  desc "start", "init team slug"
  def start
    Team.all.find_each do |team|
      team.update_column :slug, team.name.parameterize(locale: :vi)
    end
  end
end
