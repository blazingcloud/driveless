class FriendshipsController < ApplicationController

  before_filter :require_user

  def index
    users = params[:lb_co2].present? ? User.by_lb_co2 : User.by_green_miles
    users = users.with_aggregated_stats_for_destination
    users = users.filter_trip_destination(params[:destination_id]) if params[:destination_id]

    @friends = users.in( current_user.friends.map{|u| u.id} ).paginate(:page => params[:page] || 1)
    @fans = users.in(Friendship.of(current_user).map{|f| f.user_id}).paginate(:page => params[:page] || 1)
  end

  def show
    @friends = User.find_by_name(params[:username]).friends.by_green_miles.paginate(:page => params[:page] || 1)
    @fans = User.find( Friendship.of( User.find_by_name(params[:username]) ).map{|f| f.user_id} ).paginate(:page => params[:page] || 1)
  end

  def destroy
    current_user.unfriendship_to(params[:id])
    redirect_to account_friends_url
  end

  def new
  end

  def create
    current_user.friendship_to(params[:friend_id])
    redirect_to account_friends_url
  end

end
