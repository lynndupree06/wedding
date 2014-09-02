class Party < ActiveRecord::Base
  require 'csv'

  has_many :guests

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Name Address City State PostalCode Country)

      Party.order(:outer_envelop).each do |p|
        csv << [p.outer_envelop, p.address, p.city, p.state, p.postal_code, p.country]
      end
    end
  end

  def self.place_cards_to_csv
    CSV.generate do |csv|
      csv << %w(PartyName FirstName LastName Meal Table)

      Party.where(:rsvp => true).order(:name).each do |p|
        p.guests.each do |g|
          csv << [p.name, g.first_name, g.last_name, g.meal_option, g.table]
        end
      end
    end
  end
end
