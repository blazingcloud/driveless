# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user, :admin_logged_in?

  private

  def current_user
    User.last
  end

  # Placeholder methods

  def require_user
    true
  end

  def require_admin
    true
  end

  def require_no_user
    redirect_to account_path
  end

  def admin_logged_in?
    true
  end

end
