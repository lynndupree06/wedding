module GuestsHelper
  def title_options
    [%w(Mr. Mr.), %w(Mrs. Mrs.), %w(Ms. Ms.)]
  end

  def party_options
    Party.order(:name).all.map { |p| [p.name, p.id] }
  end

  def group_options
    Group.order(:name).all.map { |g| [g.name, g.id] }
  end
end
