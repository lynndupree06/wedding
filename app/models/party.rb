class Party < ActiveRecord::Base
  require 'csv'

  has_many :guests

  def self.rsvp_details
    CSV.generate do |csv|
      csv << %w(PartyName Guest1_FirstName Guest2_LastName RSVP RSVP_Size Guests)

      Party.order(:name).where(:a_b_list => 'A').each do |p|
        guests = p.guests.map(&:first_name).join(',').split(',')
        csv << [p.name, p.guests.first.first_name, p.guests.first.last_name, p.rsvp, p.size, guests]
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(PartyName Name Address City State PostalCode Country)

      Party.order(:name).each do |p|
        csv << [p.name, p.outer_envelop, p.address, p.city, p.state, p.postal_code, p.country]
      end
    end
  end

  def self.to_csv_detail
    CSV.generate do |csv|
      csv << %w(PartyName Size Address City State PostalCode Country Guests Group)

      Party.order(:name).where(:a_b_list => 'A').each do |p|
        guests = p.guests.map(&:first_name).join(',').split(',')
        temp = GroupsGuests.where(:guest_id => p.guests.first.id).map(&:group_id).join(',').split(',')

        groups = []
        temp.each do |t|
          groups << Group.find(t).name
        end

        csv << [p.name, p.guests.count, p.address, p.city, p.state, p.postal_code, p.country, guests, groups]
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

      Party.where(:a_b_list => list).order(:name).where(:rsvp => true).each do |p|
        num_of_guests = p.size

        child = []
        child[0] = {:first_name => '', :last_name => ''}
        child[1] = {:first_name => '', :last_name => ''}
        child[2] = {:first_name => '', :last_name => ''}
        child[3] = {:first_name => '', :last_name => ''}
        child[4] = {:first_name => '', :last_name => ''}
        child[5] = {:first_name => '', :last_name => ''}
        child[6] = {:first_name => '', :last_name => ''}

        # get first non-chlid guest
        idx = 0
        if p.guests.present?
          while p.guests[idx].child
            idx = idx + 1
          end

          main_guest = p.guests[idx]

          # if there is more than one guest
          if num_of_guests > 1
            # add all the other guests other than the first guest
            idx = 0
            while p.guests[idx] == main_guest
              idx = idx + 1
            end

            # add guest
            second_guest = p.guests[idx] # = p.guests[idx].first_name || "Unknown"

            # add children/other guests
            idx = 0
            child_idx = 0

            p.guests.each do |guest| 
              if guest != main_guest && guest != second_guest
                child[child_idx][:first_name] = guest.first_name
                child[child_idx][:last_name] = guest.last_name
                child_idx = child_idx + 1
              end
            end
          end

        end

        row = [main_guest.first_name, main_guest.last_name]
        if second_guest
          row << second_guest.first_name
          last_name = second_guest.last_name
          # Add suffix if suffix exists
          last_name << ", #{p.guests[idx].suffix}" if p.guests[idx].suffix.present?
          row << last_name
        else
          row << ''
          row << ''
        end

        child.each do |c|
          row << c[:first_name]
          row << c[:last_name]
        end

        csv << row
      end
    end
  end
end
