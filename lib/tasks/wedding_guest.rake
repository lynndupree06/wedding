namespace :import do
  require 'csv'

  desc 'Import csv file of guest into database'
  task wedding_guests: :environment do
    file = 'db/csv/guests.csv'

    CSV.foreach(file, :headers => true) do |row|
      guest = row.to_hash
      group = Group.find_by_name(guest['Group'])

      party = Party.find_by_name(guest['Party_Name'])
      if party.nil?
        party = Party.create(
            :name => "#{guest['First_Name']} #{guest['Last_Name']} Party"
        )
      end

      Guest.create!(
          :title => guest['Title'],
          :suffix => guest['Suffix'],
          :last_name => guest['Last_Name'],
          :first_name => guest['First_Name'],
          :address1 => guest['Street1'],
          :address2 => guest['Street2'],
          :city => guest['City'],
          :state => guest['State'],
          :postal_code => guest['Zip'],
          :country => guest['Country'],
          :email => nil,
          :group => group,
          :party => party
      )
    end
  end

end
