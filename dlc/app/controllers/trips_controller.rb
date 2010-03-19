class TripsController < InheritedResources::Base
  actions :index, :show, :new, :create, :edit, :update, :destroy

  protected
  def collection
    @trips ||= end_of_association_chain.paginate :page => params[:page], :per_page => (params[:per_page] || 20)
  end
end
