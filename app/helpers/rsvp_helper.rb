module RsvpHelper
	def party_options
		Party.order(:name).where(:rsvp => false)
	end
end
