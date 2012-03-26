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
    #return "<span class='you'>this is your group!</span>" if group.owned_by?(current_user)

    membership = group.membership_for(current_user)
    if membership
      button_to 'leave', {:controller => "memberships", :action => "destroy", :id => membership.id}, :method => :delete, :class => 'button small'
    else
      button_to 'join', {:controller => "memberships", :action => "create", :group_id => group.id}, :class => 'button small'
    end
  end

  def link_to_friendship_action( user )
    return "<span class='you'>this is you!</span>" if user == current_user
    friend = current_user.friendship_for(user)
    if friend
#      link_to 'hide friend', friend, :method => :delete, :confirm => "Are you sure?", :class => 'button small'
      button_to 'hide friend', {:controller => 'friendships', :action => "destroy", :id => friend.id}, :method => :delete, :confirm => "Are you sure?", :class => 'button small'
    else
#      link_to 'add friend', friendships_path(:friend_id => user.id), :method => :post, :class => 'button small'
      button_to 'add friend', {:controller => 'friendships', :action => 'create', :friend_id => user.id}, :method => :post, :class => 'button small'
    end
  end
  def link_to_group_delete_action_if_group( group )
    if group.is_a?(Group)
      button_to 'delete group', {:controller => 'groups', :action => 'destroy', :id => group.id}, :method => :delete, :class => 'button small'
    end
  end
end


