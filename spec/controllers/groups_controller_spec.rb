require 'spec_helper'

describe GroupsController do
  include Devise::TestHelpers
  context "with an owner and a group" do
    before do
      @owner = User.make
      @destination = Destination.make(:name => 'Madison WI')
      @group = Group.make(:name => 'My Group', :owner => @owner, :destination => @destination)
    end
    context "when merging a group " do
      before do
        @group_to_merge = Group.make(:name        => 'This is a Group to Merge',
                                     :owner       => @owner,
                                     :destination => @destination)
      end
      context "as a user" do
        before do
          sign_in User.make
        end
        it "cannot be merged by someone other than the owner" do
          lambda do
            post :merge, :id  => @group.id, :merge => {:group_id => @group_to_merge.id}
          end.should raise_error
        end
      end
      context "as a owner" do
        before do
          sign_in @owner
        end
        it "owner can merge members and the old group is destroyed" do
          mock(Group).find(@group.id) {@group}
          mock(Group).find(@group_to_merge.id) {@group_to_merge}
          mock(@group).merge(@group_to_merge)
          post :merge, :id  => @group.id, :merge => {:group_id => @group_to_merge.id}
          
          response.should redirect_to("/group/#{@group.id}")
        end
      end
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
