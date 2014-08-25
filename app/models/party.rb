class Party < ActiveRecord::Base
  require 'csv'
  
  has_many :guests

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Name Address City State PostalCode Country)

      Party.all.each do |p|
        csv << [p.outer_envelop, p.address, p.city, p.state, p.postal_code, p.country]
      end
    end
  end
end
