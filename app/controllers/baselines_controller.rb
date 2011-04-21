class BaselinesController < InheritedResources::Base
  before_filter :authenticate_user!

  actions :index, :show, :new, :create, :edit, :update, :destroy

  def update
    update! { account_path }
  end

  protected
  def collection
    @baselines ||= end_of_association_chain.paginate :page => params[:page], :per_page => (params[:per_page] || 20)
  end
end
