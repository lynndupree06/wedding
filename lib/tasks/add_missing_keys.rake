namespace :update do

  desc 'Generate missing keys for parties'
  task keys: :environment do
    Party.all.each do |p|
      if p.key.blank?
        p.key = SecureRandom.hex(3).upcase
        p.save
      end
    end
  end
end
