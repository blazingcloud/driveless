class MembershipsController < ApplicationController
  before_filter :require_user

  def destroy
    membership = current_user.memberships.find(params[:id])
    current_user.memberships.delete(membership)
    flash[:notice] = "Successfully left #{membership.group.name}!"
    redirect_to :back
  end

  def create
    group = Group.find(params[:group_id])
    membership = current_user.join(group)
    current_user.trips.create!(
      :mode_id => Mode.find(:first).id,
      :unit_id => Unit.find(:first).id,
      :destination_id => Destination.find(:first).id,
      :distance => 0,
      :is_hidden => true
    ) if current_user.trips.length == 0
    if !membership.new_record?
      flash[:notice] = "Successfully joined #{group.name}!"
    else
      flash[:warning] = "There were errors joining the group: #{membership.errors.full_messages.to_sentece}"
    end
    redirect_to :back
  end
end
