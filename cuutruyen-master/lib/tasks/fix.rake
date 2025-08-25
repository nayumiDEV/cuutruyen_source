namespace :fix do
  desc "TODO"
  task page: :environment do
    Page.find_each do |page|
      unless page.image(:normal).present?
        puts "got: #{page.chapter.id} - #{page.id}"
        attacher = page.image_attacher
        old_derivatives = attacher.derivatives

        attacher.set_derivatives({})
        attacher.create_derivatives

        begin
          attacher.atomic_persist
          attacher.delete_derivatives(old_derivatives)
          puts "done: #{page.chapter.id} - #{page.id}"
        rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
          attacher.delete_derivatives
          puts "nope: #{page.chapter.id} - #{page.id}"
        end
      end
    end
  end

end
