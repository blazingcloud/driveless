require 'spec_helper'

describe GroupsController do
  include Devise::TestHelpers
  context "when deleting a group" do
    before do
      @owner = User.make
      @destination = Destination.make(:name => 'Madison WI')
      @group = Group.make(:name => 'My Group', :owner => @owner, :destination => @destination)
    end

    it "cannot be destroyed by someone other than the owner" do
      lambda do
        delete :destroy, :id => @group.id
      end.should_not change(Group,:count).by(-1)

    end
    context "as the owner" do
      it "can be destroyed" do
        sign_in @owner
        lambda do
          delete :destroy, :id => @group.id
        end.should change(Group,:count).by(-1)
      end
    end
  end
end
