require 'spec_helper'

describe 'results routing' do
  it "has csv path" do
    {:post =>"/results_csv"}.should route_to(:controller => 'results', :action => 'csv')
  end
end
