class TripsController < InheritedResources::Base
  before_filter :authenticate_user!

  actions :index, :show, :new, :create, :edit, :update, :destroy

  def create
    create! { account_url }
  end

  def update
    update!{ account_url }
  end

  def destroy
    destroy! { account_url }
  end
  
  protected
    def collection
      @trips ||= end_of_association_chain.paginate :page => params[:page], :per_page => (params[:per_page] || 20)
    end

    def begin_of_association_chain
      current_user
    end
end
