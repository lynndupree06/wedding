def update_guest(guest, new_guest)
  party = guest.party

  if party && guest.first_name && (party.name.include? new_guest['First Name'])
    party.address = new_guest['Address']
    party.city = new_guest['City']
    party.state = new_guest['State']
    party.postal_code = new_guest['Postal Code']
    party.country = new_guest['Country']
    party.email = new_guest['Email']
    party.save!
  end
end

namespace :update do
  require 'csv'

  desc 'Import csv file of guests from Google Drive and update database info'
  task wedding_guests: :environment do
    file = 'db/csv/new_guests.csv'

    CSV.foreach(file, :headers => true) do |row|
      new_guest = row.to_hash

      if new_guest['Last Name'] && (new_guest['Last Name'].include?('Jr') || new_guest['Last Name'].include?('Sr'))
        suffix = new_guest['Last Name'].match(/[J|S]r./).to_s
        last_name = new_guest['Last Name'].match(/.*,/).to_s.chomp(',')
        guests = Guest.where(suffix: suffix, last_name: last_name)
      else
        guests = Guest.where(last_name: new_guest['Last Name'])
      end

      if guests.size > 1
        guests.each do |guest|
          update_guest(guest, new_guest)
        end
      elsif guests.size == 1
        update_guest(guests[0], new_guest)
      else
        if new_guest['Bride Guest']
          group = Group.find_by_name("Bride's Friends")
        else
          group = Group.find_by_name("Groom's Friends")
        end

        party = Party.create!(
            :name => "#{new_guest['First Name']} #{new_guest['Last Name']} Party",
            :address => new_guest['Address'],
            :city => new_guest['City'],
            :state => new_guest['State'],
            :postal_code => new_guest['Postal Code'],
            :country => new_guest['Country'],
            :email => new_guest['Email'],
            :save_the_date_sent => false,
            :rsvp => false,
            :key => SecureRandom.hex(3).upcase
        )

        guest = Guest.create!(
            :last_name => new_guest['Last_Name'],
            :first_name => new_guest['First_Name'],
            :party => party
        )

        GroupsGuests.create(
            :group_id => group.id,
            :guest_id => guest.id
        )
      end
    end
  end
end