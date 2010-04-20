# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_nav(name, options, html_options = {})
    description = html_options[:description] ? html_options.delete(:description) : ''
    html_class = current_page?(options) ? 'current' : ''
    "<li class='#{html_class}'>" + 
      link_to(name, options, html_options) +
      "<span class='desc'>#{description}</span>" +
    '</li>'
  end

  def link_to_membership_action(group)
    return "yours" if group.owned_by?(current_user)

    membership = group.membership_for(current_user)
    if membership
      link_to 'leave', membership, :method => :delete, :confirm => "Are you sure?", :class => 'button small'
    else
      link_to 'join', memberships_path(:group_id => group.id), :method => :post, :class => 'button small'
    end
  end

  def link_to_friendship_action( user )
    return "you" if user == current_user
    friend = current_user.friendship_for(user)
    if friend
      link_to 'hide friend', friend, :method => :delete, :confirm => "Are you sure?", :class => 'button small'
    else
      link_to 'add friend', friendships_path(:friend_id => user.id), :method => :post, :class => 'button small'
    end
  end
end


