module ApplicationHelper
  def active_class(url)
    request.fullpath == url ? 'active' : nil
  end

  def guest_data(list)
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

  def group_data(list, group_id)
    "<td>#{number_of_guests_in_party list, group_id}</td>
        <td>#{number_of_parties list, group_id}</td>
        <td>#{number_of_males list, group_id}</td>
        <td>#{number_of_females list, group_id}</td>
        <td>#{number_of_children list, group_id}</td>".html_safe
  end

  private

  def number_of_parties(list, group_id = nil)
    if group_id
      Party.joins(guests: :group).where(a_b_list: list).where("group_id = #{group_id}").uniq(:party).count
    else
      Party.where(a_b_list: list).count
    end
  end

  def number_of_guests_in_party(list, group_id = nil)
    if group_id
      Guest.joins(:party).joins(:group).where("parties.a_b_list = '#{list}' AND group_id = #{group_id}").count
    else
      Guest.joins(:party).where("parties.a_b_list = '#{list}'").count
    end
  end

  def number_of_females(list, group_id = nil)
    if group_id
      Guest.joins(:party).joins(:group).where(gender: 'Female', child: false).where("parties.a_b_list = '#{list}' AND group_id = #{group_id}").count
    else
      Guest.joins(:party).where(gender: 'Female', child: false).where("parties.a_b_list = '#{list}'").count
    end
  end

  def number_of_males(list, group_id = nil)
    if group_id
      Guest.joins(:party).joins(:group).where(gender: 'Male', child: false).where("parties.a_b_list = '#{list}' AND group_id = #{group_id}").count
    else
      Guest.joins(:party).where(gender: 'Male', child: false).where("parties.a_b_list = '#{list}'").count
    end
  end

  def number_of_children(list, group_id = nil)
    if group_id
      Guest.joins(:party).joins(:group).where(child: true).where("parties.a_b_list = '#{list}' AND group_id = #{group_id}").count
    else
      Guest.joins(:party).where(child: true).where("parties.a_b_list = '#{list}'").count
    end
  end

  def number_in_group(list, group)
    Guest.joins(:group).joins(:party)
    .where("parties.a_b_list = '#{list}' AND groups_guests.group_id = '#{group}'").count
  end
end
