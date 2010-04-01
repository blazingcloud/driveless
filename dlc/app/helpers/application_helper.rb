# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_nav(name, options, html_options = {})
    html_class = current_page?(options) ? 'current' : ''
    "<li class='#{html_class}'>" + 
      link_to(name, options, html_options) +
    '</li>'
  end
end
