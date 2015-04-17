class Party < ActiveRecord::Base
  require 'csv'

  has_many :guests

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(PartyName Name Address City State PostalCode Country)

      Party.order(:name).each do |p|
        csv << [p.name, p.outer_envelop, p.address, p.city, p.state, p.postal_code, p.country]
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

  def self.seating_chart_to_csv(list)
    CSV.generate do |csv|
      csv << ['First Name', 'Last Name', 'Guest First Name', 'Guest Last Name',
              'Child First Name 1', 'Child Last Name 1', 'Child First Name 2', 'Child Last Name 2',
              'Child First Name 3', 'Child Last Name 3', 'Child First Name 4', 'Child Last Name 4']

      Party.where(:a_b_list => list).order(:name).each do |p|
        num_of_guests = p.guests.size

        idx = 0
        if p.guests.present?
          first_name = p.guests[idx].first_name
          last_name = p.guests[idx].last_name
        end
        # last_name << ", #{p.guests[idx].suffix}" if p.guests[idx].suffix.present?

        guest_first_name = ''
        guest_last_name = ''
        child = []
        child[0] = {:first_name => '', :last_name => ''}
        child[1] = {:first_name => '', :last_name => ''}
        child[2] = {:first_name => '', :last_name => ''}
        child[3] = {:first_name => '', :last_name => ''}

        idx = idx + 1
        guest_idx = idx
        while num_of_guests > guest_idx && guest_first_name.blank?
          if !p.guests[idx].child
            guest_first_name = p.guests[idx].first_name || "Unknown"
            guest_last_name = p.guests[idx].last_name
            idx = idx + 1
          end
          guest_idx = guest_idx + 1
        end

        child_idx = 0
        while num_of_guests > idx && guest_first_name != p.guests[idx].first_name
          child[child_idx][:first_name] = p.guests[idx].first_name || "Unknown"
          child[child_idx][:last_name] = p.guests[idx].last_name
          child_idx = child_idx + 1
          idx = idx + 1
        end

        csv << [first_name, last_name, guest_first_name, guest_last_name,
                child[0][:first_name], child[0][:last_name], child[1][:first_name], child[1][:last_name],
                child[2][:first_name], child[2][:last_name], child[3][:first_name], child[3][:last_name]]
      end
    end
  end
end
