require 'spec_helper'

describe 'results routing' do
  it "has csv path" do
    {:get =>"/results_csv"}.should route_to(:controller => 'results', :action => 'csv')
  end
  it "has raw csv path" do
    {:get =>"/raw_results_csv"}.should route_to(:controller => 'results', :action => 'raw_csv')
  end
  it "has group csv path" do
    {:get =>"/group_results_csv"}.should route_to(:controller => 'results', :action => 'group_csv')
  end
  it "has parent csv path" do
    {:get =>"/parent_results_csv"}.should route_to(:controller => 'results', :action => 'parent_csv')
  end
end
