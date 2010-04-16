class FriendshipsController < ApplicationController

  def index
    @friends = current_user.friends.by_green_miles
  end

  def show
    @friends = User.find_by_name(params[:username]).friends.by_green_miles
  end

  def destroy
    current_user.unfriendship_to(params[:id])
    redirect_to account_friendships_url
  end

  def new
  end

  def create
    current_user.friendship_to(params[:friend_id])
    redirect_to account_friendships_url
  end

end
