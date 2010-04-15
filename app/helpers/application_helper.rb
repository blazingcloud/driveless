# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_nav(name, options, html_options = {})
    html_class = current_page?(options) ? 'current' : ''
    "<li class='#{html_class}'>" + 
      link_to(name, options, html_options) +
    '</li>'
  end

  def link_to_membership_action(group)
    return "yours" if group.owned_by?(current_user)

    membership = group.membership_for(current_user)
    if membership
      link_to 'leave', membership, :method => :delete, :confirm => "Are you sure?"
    else
      link_to 'join', memberships_path(:group_id => group.id), :method => :post
    end
  end
end