class MembershipsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    membership = current_user.memberships.find(params[:id])
    current_user.memberships.delete(membership)
    flash[:notice] = "Successfully left #{membership.group.name}!"
    redirect_to :back
  end

  def create
    group = Group.find(params[:group_id])
    membership = current_user.join(group)
    if !membership.new_record?
      flash[:notice] = "Successfully joined #{group.name}!"
    else
      flash[:warning] = "There were errors joining the group: #{membership.errors.full_messages.to_sentence}"
    end
    redirect_to :back
  end
end
