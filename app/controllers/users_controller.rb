class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:show, :edit, :update]
  before_filter :collect_communities, :only => [ :edit, :update, :new, :create ]
  before_filter :require_admin, :only => [ :destroy ]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def index
    redirect_to root_path if not current_user.admin?
    @users = User.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def csv
    redirect_to root_path if not current_user.admin?
    users = User.order(:name).where("email not like '%my.drivelesschallenge.com'")

    csv_string = FasterCSV.generate do |csv|
      csv << [
        "Name",
        "Username",
        "Email",
        "Address",
        "City",
        "Community",
        "Last login at",
        "Date created",
        "Has baseline",
        "# logged trips",
        "Date of last trip",
        "Is parent"
      ]

      users.each do |user|
        csv << [
          user.name,
          user.username,
          user.email,
          user.address,
          user.city,
          user.community.try(:name),
          user.current_sign_in_at.try(:to_s, :short),
          user.created_at.try(:to_s, :short),
          user.baseline.present? ? "yes" : "no",
          user.trips.count,
          user.trips.order('made_at desc').try(:first).try(:made_at).try(:to_s, :short),
          user.is_parent? ? "yes" : "no"
        ]
      end
    end

    filename = "dlc-tool-userlist.csv"
    send_data(csv_string,
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => filename)
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
    @user = params[:id] ? User.find(params[:id]) : current_user
    @trip = Trip.new
  end

  def collect_communities
    @communities = Community.find(:all, :order => "name")
  end

  def edit
    if current_user.admin? and params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def privacy
  end

  def update
    if current_user.admin? and params[:user]
      @user = User.find(params[:user][:id])
    else
      @user = current_user
    end
    @user = User.find(@user.id)
    attr = params[:user]
    if attr[:password].blank? && attr[:password_confirmation].blank?
      attr.delete(:password)
      attr.delete(:password_confirmation)
    end
    @user.attributes = attr

    if @user.facebook_uid && !@user.crypted_password
      p = @user.newpass(8)
      @user.password= p
      @user.password_confirmation= p
      @user.is_13= true
      @user.read_privacy= true
      @user.save
    end
    if @user.save
      flash[:notice] = "Successfully updated profile."
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end
end
