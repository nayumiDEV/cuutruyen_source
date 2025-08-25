namespace :do do
  desc "TODO"
  task clean: :environment do
    file_system = Shrine.storages[:cache]
    file_system.clear! { |path| path.mtime < 3.days.ago }
  end

end
