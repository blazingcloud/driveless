class CommunitiesController < ApplicationController
  before_filter :require_admin, :except => :show

  def new
    @community = Community.new
  end

  def edit
    render :partial => "form"
  end

  def index
    @communities = Community.find(:all)
  end


  def create
    @community = Community.new(params[:community])
    @community.save do |result|
      if result
        flash[:notice] = "Community #{@community.name} created successfully!"
        redirect_to root_url
      else
        render :action => 'new'
      end
    end
  end

  private

end
