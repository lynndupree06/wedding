module GuestsHelper
  def title_options
    %w(Mr. Mrs. Ms. Dr. Rev.)
  end

  def party_options
    Party.order(:name).all.map { |p| p.name }
  end

  def group_options
    Group.order(:name).all.map { |g| [g.id, g.name] }
  end
end
