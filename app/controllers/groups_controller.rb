class GroupsController < ApplicationController

  before_filter :collect_destinations, :only => [ :new, :edit ]
  before_filter :is_the_owner?, :only => [ :destroy, :edit ]

  def show
    @groups = Group.paginate(:page => params[:page] || 1)
  end
  def index
    @groups = Group.paginate(:page => params[:page] || 1, :conditions => { :owner_id => current_user })
  end
  def new
    @group = Group.new
  end
  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "Group #{@group.name} created successfully!"
      redirect_to groups_url
    else
      flash[:alert] = "There Are Errors in the fields!"
      redirect_to new_group_url
    end
  end
  def edit
    @group = current_group
    render :new
  end
  def update
    @group = current_group
    redirect_to groups_url
  end
  def destroy
    current_group.destroy
    redirect_to groups_url
  end

  def current_group
    Group.find(params[:id])
  end

  private

  def is_the_owner?
    group = Group.find(params[:id])
    group.owner == current_user
  end

  def collect_destinations
    @destinations = Destination.all
  end
end
