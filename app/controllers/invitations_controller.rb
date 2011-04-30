class InvitationsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @invitation = Invitation.new
    render :new
  end

  def create
    @invitation = current_user.send_invitation!(params[:invitation])
    # TODO, just for now, will fix this later
    if @invitation
      flash[:notice] = "The invitation was sent"
    else
      flash[:alert] = "There were errors in your invitation"
    end
    redirect_to invitations_url
  end

end
