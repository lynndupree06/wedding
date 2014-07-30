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
            :name => "#{guest['Party_Name']} Party",
            :address => guest['Address'],
            :city => guest['City'],
            :state => guest['State'],
            :postal_code => guest['Zip'],
            :country => guest['Country'],
            :email => nil
        )
      end

      Guest.create!(
          :title => guest['Title'],
          :suffix => guest['Suffix'],
          :last_name => guest['Last_Name'],
          :first_name => guest['First_Name'],
          :gender => guest['Gender'],
          :a_b_list => guest['A/B_List'],
          :group => group,
          :party => party
      )

      if guest['Spouse_Guest_First_Name'] || guest['Spouse_Guest_Last_Name']
        Guest.create!(
            :title => guest['Spouse_Guest_Title'],
            :suffix => guest['Spouse_Guest_Suffix'],
            :last_name => guest['Spouse_Guest_Last_Name'],
            :first_name => guest['Spouse_Guest_First_Name'],
            :gender => guest['Spouse_Guest_Gender'],
            :a_b_list => guest['A/B_List'],
            :group => group,
            :party => party
        )
      end

      if guest['Child1_First_Name'] || guest['Child1_Last_Name']
        Guest.create!(
            :title => guest['Child1_Title'],
            :suffix => guest['Child1_Suffix'],
            :last_name => guest['Child1_Last_Name'],
            :first_name => guest['Child1_First_Name'],
            :gender => guest['Child1_Gender'],
            :a_b_list => guest['A/B_List'],
            :group => group,
            :party => party
        )
      end

      if guest['Child2_First_Name'] || guest['Child2_Last_Name']
        Guest.create!(
            :title => guest['Child2_Title'],
            :suffix => guest['Child2_Suffix'],
            :last_name => guest['Child2_Last_Name'],
            :first_name => guest['Child2_First_Name'],
            :gender => guest['Child2_Gender'],
            :a_b_list => guest['A/B_List'],
            :group => group,
            :party => party
        )
      end

      if guest['Child3_First_Name'] || guest['Child3_Last_Name']
        Guest.create!(
            :title => guest['Child3_Title'],
            :suffix => guest['Child3_Suffix'],
            :last_name => guest['Child3_Last_Name'],
            :first_name => guest['Child3_First_Name'],
            :gender => guest['Child3_Gender'],
            :a_b_list => guest['A/B_List'],
            :group => group,
            :party => party
        )
      end
    end
  end

end
