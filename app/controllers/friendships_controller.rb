class FriendshipsController < ApplicationController

  before_filter :authenticate_user!

  def index
    mode_id = params[:mode_id].to_i
    if mode_id.zero?
      sort_by = params[:sort_by].to_sym if params[:sort_by].present?
      @friends = current_user.friends_leaderboard(sort_by)
      @fans = current_user.fans_leaderboard(sort_by)
    else
      @friends = current_user.friends_leaderboard_by(mode_id)
      @fans = current_user.fans_leaderboard_by(mode_id)
    end
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
    begin
      current_user.friendship_to(params[:friend_id])
    rescue User::MailError
      flash[:notice] = "Error sending friendship notification"
    end
    redirect_to account_friends_url
  end

end
