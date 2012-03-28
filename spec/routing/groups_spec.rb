require 'spec_helper'

describe 'group routing' do
  it "has a merge end point" do
    {:post =>"/account/groups/3/merge"}.should route_to(:controller => 'groups', :action => 'merge', :id => '3')
  end
end
