namespace :backup do
  desc "Trigger backup sequence"

  task database: :environment do
    BackupDatabaseJob.perform_now
  end

  task storage: :environment do
    BackupStorageJob.perform_now
  end
end
