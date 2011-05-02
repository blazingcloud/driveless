class ApplicationController < ActionController::Base

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :admin_logged_in?, :communities

  #private

  # Placeholder methods

  #def require_user
    #true
  #end

  def require_admin
    not_allowed unless admin_logged_in?
  end

  #def require_no_user
    #redirect_to account_path
  #end

  def admin_logged_in?
    current_user && current_user.admin?
  end

  def communities
    @communities ||= Community.find(:all, :order => "name")
  end

  def index
  end
end
