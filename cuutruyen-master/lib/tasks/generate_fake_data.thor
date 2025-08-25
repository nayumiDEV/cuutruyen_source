require 'faker'
require 'securerandom'

class GenerateFakeData < Thor
  include Thor::Actions

  desc "donations COUNT", "Generate fake donation data"
  def donations(count = 10)
    say "Generating #{count} fake donations...", :yellow

    count.to_i.times do |i|
      user = User.order("RANDOM()").first
      
      # Randomly decide if this should be a negative donation (spending)
      is_negative = [true, false].sample
      
      if is_negative
        # For negative donations (spending), set amount to negative and nil out certain fields
        donation = Donation.new(
          amount: -Faker::Number.between(from: 10, to: 1000) * 1000, # Negative amount for spending
          message: Faker::Lorem.sentence(word_count: 5),
          sepay_id: "SEPAY#{SecureRandom.hex(8).upcase}",
          sepay_reference_code: "REF#{SecureRandom.hex(4).upcase}",
          created_at: Faker::Time.between(from: 1.month.ago, to: Time.now),
          updated_at: Time.now
        )
      else
        # Regular donation with all fields
        donation = Donation.new(
          amount: Faker::Number.between(from: 10, to: 1000) * 1000, # Amount in VND (1k-1M VND)
          unique_code: "CUUTR#{SecureRandom.random_number(10**16).to_s.rjust(16, '0')}",
          message: Faker::Lorem.sentence(word_count: 5),
          name: Faker::Name.name,
          email: Faker::Internet.email,
          sepay_id: "SEPAY#{SecureRandom.hex(8).upcase}",
          sepay_reference_code: "REF#{SecureRandom.hex(4).upcase}",
          user: [user, nil].sample, # Randomly assign to a user or keep as guest
          created_at: Faker::Time.between(from: 1.month.ago, to: Time.now),
          updated_at: Time.now
        )
      end

      if donation.save
        say "Created donation ##{i+1}: #{donation.amount.to_i} VND by #{donation.name}", :green
      else
        say "Error creating donation: #{donation.errors.full_messages.join(', ')}", :red
      end
    end

    say "\nSuccessfully generated #{count} fake donations!", :green
  end

  private

  def app
    @app ||= begin
      require File.expand_path('config/application', destination_root)
      Rails.application.initialize!
      Rails.application
    end
  end
end
