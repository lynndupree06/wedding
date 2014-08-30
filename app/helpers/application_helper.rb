module ApplicationHelper
  def active_class(url)
    request.fullpath == url ? "active" : nil
  end

  def number_of_parties(list)
    Party.where(a_b_list: list).count
  end

  def number_of_guests_in_party(list)
    Guest.joins(:party).where("parties.a_b_list = '#{list}'").count
  end

  def number_of_females(list)
    Guest.joins(:party).where(gender: 'Female', child: false).where("parties.a_b_list = '#{list}'").count
  end

  def number_of_males(list)
    Guest.joins(:party).where(gender: 'Male', child: false).where("parties.a_b_list = '#{list}'").count
  end

  def number_of_children(list)
    Guest.joins(:party).where(child: true).where("parties.a_b_list = '#{list}'").count
  end

  def number_in_group(list, group)
    Guest.joins(:group).joins(:party)
      .where("parties.a_b_list = '#{list}' AND groups_guests.group_id = '#{group}'").count
  end

  def group_data(list)
    "<td>#{number_of_guests_in_party list}</td>
    <td>#{number_of_parties list}</td>
    <td>#{number_of_males list}</td>
    <td>#{number_of_females list}</td>
    <td>#{number_of_children list}</td>
    <td>#{number_in_group list, 1}</td>
    <td>#{number_in_group list, 2}</td>
    <td>#{number_in_group list, 3}</td>
    <td>#{number_in_group list, 4}</td>".html_safe
  end
end
