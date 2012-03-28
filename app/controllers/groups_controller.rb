class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_group, :only => [:show, :edit, :update, :destroy, :merge]
  before_filter :is_the_owner?, :only => [ :destroy, :update, :edit ,:merge]

  def show
    mode_id = params[:mode_id].to_i
    if mode_id.zero?
      sort_by = params[:sort_by].to_sym if params[:sort_by].present?
      @members_leaderboard = @group.members_leaderboard(sort_by)
    else
      @members_leaderboard = @group.members_leaderboard_by(params[:mode_id])
    end
  end

  def index
    @owned_groups = Group.find_leaderboard_owned_by(current_user, params[:sort_by] || :miles)
    @groups_as_member = Group.find_leaderboard_for_member(current_user, params[:sort_by] || :miles)
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
    @group = current_user.create_group(params[:group], params[:not_member])
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
  def merge
    @merge_group = Group.find(params[:merge][:group_id])
    @group.merge(@merge_group)
    redirect_to group_path(@group) 
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
