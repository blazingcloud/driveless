class GroupsController < ApplicationController
  def index
    @groups = Group.paginate(:page => params[:page] || 1)
  end
end
