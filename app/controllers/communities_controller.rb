class CommunitiesController < ApplicationController
  before_filter :require_admin, :except => :show

  def new
    @community = Community.new
  end

  def edit
    @community = current_community
    render :new
  end

  def update
    @community = current_community
    if @community.update_attributes(params[:community])
      redirect_to communities_url
    end
  end

  def index
    @communities = Community.find(:all)
  end

  def destroy
    current_community.destroy
    redirect_to communities_url
  end

  def show
    @community = current_community
    @users = @community.users.by_green_miles
  end

  def create
    @community = Community.new(params[:community])
    if @community.save
      flash[:notice] = "Community #{@community.name} created successfully!"
      redirect_to communities_url
    else
      flash[:alert] = "There Are Errors in the fields!"
      redirect_to new_community_url
    end
  end

  private

  def current_community
    @community ||= Community.find_by_id(params[:id])
  end
end
