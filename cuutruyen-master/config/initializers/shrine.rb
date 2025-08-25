# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/s3'

b2_storage_cache =
  if Rails.env.production?
    Shrine::Storage::S3.new(
      bucket: 'cuutruyen',
      region: 'us-west-000',
      access_key_id: '0007e81d255312e0000000004',
      secret_access_key: 'K000NU1sEKKxnb1+mG1lxrs+q6QPfKM',
      endpoint: 'https://s3.us-west-000.backblazeb2.com',
      prefix: 'uploads/cache',
      force_path_style: true
    )
  else
    Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache')
  end

b2_storage_store =
  if Rails.env.production?
    Shrine::Storage::S3.new(
      bucket: 'cuutruyen',
      region: 'us-west-000',
      access_key_id: '0007e81d255312e0000000004',
      secret_access_key: 'K000NU1sEKKxnb1+mG1lxrs+q6QPfKM',
      endpoint: 'https://s3.us-west-000.backblazeb2.com',
      prefix: 'uploads',
      force_path_style: true
    )
  else
    Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
  end

Shrine.storages = {
  cache: b2_storage_cache,
  store: b2_storage_store
}

Shrine.plugin(:activerecord)
Shrine.plugin(:restore_cached_data) # re-extract metadata when attaching a cached file
Shrine.plugin(:derivatives, create_on_promote: true)
Shrine.plugin(:validation)
Shrine.plugin(:validation_helpers)
Shrine.plugin(:determine_mime_type)
Shrine.plugin(:remote_url, max_size: 10.megabytes)
Shrine.plugin(:backgrounding)
Shrine.plugin(:upload_endpoint, max_size: 50.megabytes)
Shrine.plugin(:pretty_location, class_underscore: :true)
Shrine.plugin(:refresh_metadata)

if Rails.env.production?
  Shrine.plugin(:url_options, store: { host: 'https://storage-ct.lrclib.net/file/cuutruyen/', public: true })
else
  Shrine.plugin(:url_options, store: { host: 'http://cuutruyen.localhost', public: true })
end

Shrine::Attacher.promote_block do
  PromoteJob.perform_later(self.class.name, record.class.name, record.id, name, file_data)
end

Shrine::Attacher.destroy_block do
  DestroyJob.perform_later(self.class.name, data)
end
