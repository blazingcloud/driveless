class TripsController < InheritedResources::Base
  actions :index, :show, :new, :create, :edit, :update, :destroy

  def create
    create! { account_url }
  end
  
  protected
    def collection
      @trips ||= end_of_association_chain.paginate :page => params[:page], :per_page => (params[:per_page] || 20)
    end
    def begin_of_association_chain
      current_user_session.record
    end
end
