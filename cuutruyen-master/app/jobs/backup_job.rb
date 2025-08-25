require 'aws-sdk-s3'
require 'open3'
require 'pony'

class BackupJob < ApplicationJob
  queue_as :backup

  def perform
    File.write('/tmp/.pgpass', "postgres:5432:#{ENV['PG_DATABASE']}:#{ENV['PG_USER']}:#{ENV['PG_PASSWORD']}")
    File.chmod(0600, '/tmp/.pgpass')

    backup_command = "PGPASSFILE=/tmp/.pgpass pg_dump -U #{ENV['PG_USER']} -h postgres -p 5432 -Fc #{ENV['PG_DATABASE']} > /tmp/postgres-backup.dump"
    stdout, stderr, status = Open3.capture3(backup_command)

    current_time = DateTime.now.in_time_zone('Hanoi')

    if status.success?
      result = send_to_s3! current_time
      if result
        send_success_email! current_time, stdout
      else
        send_failure_email! current_time, "Cannot send to S3!"
      end
    else
      send_failure_email! current_time, stderr
    end

    File.delete('/tmp/postgres-backup.dump') if File.exist?('/tmp/postgres-backup.dump')
    File.delete('/tmp/.pgpass') if File.exist?('/tmp/.pgpass')
  end

  private

  def send_to_s3! current_time
    s3 = Aws::S3::Resource.new(
      access_key_id: '0007e81d255312e000000000f',
      secret_access_key: 'K000ShVmeZHEHGrWCjnKhdsOG1FsnMQ',
      region: 'us-west-000',
      endpoint: 'https://s3.us-west-000.backblazeb2.com'
    )

    bucket = s3.bucket('cuutruyen-db-backup')

    time_string_file = current_time.strftime('%Y%m%d%H%M%S')
    bucket.object("cuutruyen_production-#{time_string_file}.dump").upload_file('/tmp/postgres-backup.dump')
  end

  def send_success_email! current_time, stdout
    time_string = current_time.strftime('%Y-%m-%d %H:%M')

    subject = "[SUCCESS] Database backup for CUUTRUYEN at #{time_string}"
    body = "Status: SUCCESS\n\nStdout: #{stdout}"
    send_mail! subject, body
  end

  def send_failure_email! current_time, message
    time_string = current_time.strftime('%Y-%m-%d %H:%M')

    subject = "[FAILURE] Database backup for CUUTRUYEN at #{time_string}"
    body = "Status: FAILURE\n\nMessage:#{message}"
    send_mail! subject, body
  end

  def send_mail! subject, body
    Pony.mail(
      to: 'thang.dovah@gmail.com',
      from: 'thang.dovah@gmail.com',
      subject: subject,
      body: body,
      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        user_name: 'thang.dovah@gmail.com',
        password: 'bjsqueolxxkbjauq',
        authentication: :plain,
        domain: 'mail.google.com'
      }
    )
  end
end
