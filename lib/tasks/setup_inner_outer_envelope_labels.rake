namespace :update do

  desc 'Generate inner and outer envelope titles based off of guest names'
  task envelopes: :environment do
    Party.all.each do |p|
      if p.inner_envelop.nil? && p.outer_envelop.nil?
        outer_envelope = ''
        inner_envelope = ''

        husband = p.guests.where(title: 'Mr.', child: false).first
        wife = p.guests.where(title: 'Mrs.', child: false).first

        single_female = wife.nil? ? p.guests.where(title: 'Ms.', child: false).first : ''
        children = p.guests.where(child: true)

        if husband.present? && wife.present?
          outer_envelope = "Mr. & Mrs. #{husband.first_name} #{husband.last_name}"
          inner_envelope = "#{husband.first_name}#{children.present? ? ', ' : ' & '}#{wife.first_name}"
        elsif husband.present? && wife.nil? && single_female.nil?
          outer_envelope = "Mr. #{husband.first_name} #{husband.last_name}"
          inner_envelope = "#{husband.first_name}"
        elsif single_female.present? && husband.nil? && wife.nil?
          outer_envelope = "Ms. #{single_female.first_name} #{single_female.last_name}"
          inner_envelope = single_female.first_name
        end

        outer_envelope << ", #{husband.suffix}" if husband.present? && husband.suffix.present?

        not_set = true
        count = 1
        children.each do |c|
          outer_envelope << ' & Family' if not_set
          inner_envelope << "#{count == children.size ? ' & ' : ', '}#{c.first_name}"
          not_set = false
          count = count + 1
        end

        p.outer_envelop = outer_envelope
        p.inner_envelop = inner_envelope
        p.save!
      end
    end
  end
end