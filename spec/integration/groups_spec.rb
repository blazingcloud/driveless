require 'spec_helper'

describe "Group Page" do
  context "with an owner and a group" do
    before do
      @owner = User.make(:password => 'password')
      @destination = Destination.make(:name => 'Madison WI')
      @group = Group.make(:name => 'My Group', :owner => @owner, :destination => @destination)
    end

    describe "When logged in as a member" do
      before do
        me = @group.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))
        login_as(me,'password')
      end
      context "when visiting a group" do
        before do
          visit("/account/groups")

        end
        it "i should not see edit " do
          page.should_not have_button("edit group")
        end
        it "i should not see delete button " do
          page.should_not have_button("delete group")
        end
      end

    end
    describe "When logged in as owner" do
      before do
        login_as(@owner,'password')
      end
      context "when visiting a group" do
        before do
          visit("/account/groups")

        end
        it "should have a link to edit" do
          click_on("edit group")
          current_path.should == "/account/groups/#{@group.id}/edit"
        end
        it "should have a link to delete" do
          page.should have_button("delete group")
        end
      end

      context "on the edit page" do
        before do
          visit("/account/groups/#{@group.id}/edit")
        end
        it "i can change the title" do
          fill_in "group[name]", :with => "Moogles"
          click_button "Update Group"
        end
      end
    end
  end
end
