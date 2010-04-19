class GroupsController < ApplicationController
  before_filter :require_user
  before_filter :load_group, :only => [:show, :edit, :update, :destroy]
  before_filter :is_the_owner?, :only => [ :destroy, :update, :edit ]

  def show
  end

  def index
    @owned_groups = current_user.owned_groups.by_name.paginate(:page => params[:page] || 1, :include => :destination)
    @memberships = current_user.regular_memberships.by_group_name.paginate(:page => params[:page] || 1, :include => {:group => :destination})
  end

  def index_all
    @destinations = Destination.find(:all)
    if params[:destination_id].present?
      destination = Destination.find(params[:destination_id])
      @groups = destination.groups.by_name.all.paginate(:page => params[:page] || 1)
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.create_group(params[:group])
    if !@group.new_record?
      flash[:notice] = "Group #{@group.name} created successfully!"
      redirect_to account_groups_url
    else
      render :new
    end
  end

  def edit
    render :new
  end

  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to account_groups_url
    else
      render :new
    end
  end

  def destroy
    @group.destroy
    redirect_to account_groups_url
  end

  private

  def load_group
    @group ||= Group.find(params[:id])
  end

  def is_the_owner?
    not_allowed unless @group.owned_by?(current_user)
  end
end
