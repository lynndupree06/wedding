module RsvpHelper
	def party_options
		Party.order(:name).where('rsvp != ? OR rsvp != ? OR rsvp = 0 OR rsvp IS NULL', true, 't')
	end
end
