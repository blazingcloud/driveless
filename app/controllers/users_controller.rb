class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :collect_communities, :only => [ :edit, :update, :new, :create ]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = "Registration successful."
        redirect_to root_url
      else
        render :action => 'new'
      end
    end
  end

  def index
    redirect_to root_path if not current_user.admin?
    @users = User.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url
  end 

  def widget
    @user = current_user
    if @user
      render :layout => 'widget'
    else
      render :text => "&nbsp"
    end
  end
  
  def show
    @user = @current_user
    @trip = Trip.new
  end

  def collect_communities
    @communities = Community.find(:all, :order => "name")
  end

  def edit
    if  @current_user.admin? and params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
  end
  
  def update
    if @current_user.admin? and params[:user]
      @user = User.find(params[:user][:id])
    else
      @user = @current_user
    end
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = "Successfully updated profile."
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end
  end
end

