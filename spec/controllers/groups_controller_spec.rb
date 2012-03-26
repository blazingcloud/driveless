require 'spec_helper'

describe GroupsController do
  include Devise::TestHelpers
  context "with an owner and a group" do
    before do
      @owner = User.make
      @destination = Destination.make(:name => 'Madison WI')
      @group = Group.make(:name => 'My Group', :owner => @owner, :destination => @destination)
    end
    context "when editing a group " do
      it "cannot be edited by someone other than the owner" do
        @group.name.should_not == 'bean'
        put :update, :id => @group.id, :group => {:name => 'bean'}
        @group.reload.name.should_not == 'bean'
      end
      context "as the owner" do
        before do
          sign_in @owner
        end
        it "can be edited" do
          @group.name.should_not == 'bean'
          put :update, :id => @group.id, :group => {:name => 'bean'}
          @group.reload.name.should == 'bean'
        end
      end
    end
    context "when deleting a group" do
      it "cannot be destroyed by someone other than the owner" do
        lambda do
          delete :destroy, :id => @group.id
        end.should_not change(Group,:count).by(-1)

      end
      context "as the owner" do
        before do
          sign_in @owner
        end
        it "can be destroyed" do
          lambda do
            delete :destroy, :id => @group.id
          end.should change(Group,:count).by(-1)
        end
      end
    end
  end
end
