namespace :export do
  require 'csv'

  desc 'Create a CSV file for outer envelope labels'
  task outer_envelopes: :environment do
    CSV.open('outer_envelope_labels.csv', 'wb') do |csv|
      csv << %w(Name Address City State PostalCode Country)

      Party.all.each do |p|
        csv << [p.outer_envelop, p.address, p.city, p.state, p.postal_code, p.country]
      end

      puts csv
    end
  end
end