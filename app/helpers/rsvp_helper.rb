module RsvpHelper
	def party_options
		Party.order(:name).where('rsvp != true OR rsvp IS NULL')
	end
end
