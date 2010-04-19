class CommunitiesController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, :only => [ :update, :edit, :new, :create, :destroy ]

  def new
    @community = Community.new
  end

  def edit
    @community = current_community
    render :new
  end

  def update
    if current_community.update_attributes(params[:community])
      redirect_to communities_url
    end
  end

  def index
    @communities = Community.by_green_miles.paginate(:page => params[:page] || 1)
  end

  def destroy
    current_community.destroy
    redirect_to communities_url
  end

  def show
    redirect_to root_path unless current_community
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
