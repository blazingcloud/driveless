class CommunitiesController < ApplicationController
  before_filter :require_admin, :except => :show

  def new
    @community = Community.new
  end

  def edit
    @community = Community.find(params[:id])
    render :new
  end

  def update
    @community = Community.find(params[:id])
    if @community.update_attributes(params[:community])
      redirect_to communities_url
    end
  end

  def index
    @communities = Community.find(:all)
  end

  def destroy
    Community.find(params[:id]).destroy
    redirect_to communities_url
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

end
