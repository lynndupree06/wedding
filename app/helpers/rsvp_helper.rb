module RsvpHelper
	def party_options
		Party.order(:name).where('rsvp != ? OR rsvp IS NULL', true)
	end
end
