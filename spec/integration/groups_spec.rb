require 'spec_helper'

describe "Group Page" do
  context "with an owner and a group" do
    before do
      @owner = User.make(:password => 'password')
      @destination = Destination.make(:name => 'Madison WI')
      @group = Group.make(:name => 'My Group', :owner => @owner, :destination => @destination)
      #owner is not a member by default
    end

    describe "When logged in as a member" do
      before do
        me = @group.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))
        login_as(me,'password')
      end
      context "when visiting a group" do
        before do
          visit("/group/#{@group.id}")

        end
        it "i should not see merge " do
          page.should_not have_button("merge group")
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
      context "merge group feature" do
        before do
          @destination = Destination.make(:name => 'Madison WI')

          @group_to_merge = Group.make(:name        => 'This is a Group to Merge',
                                       :owner       => @owner,
                                       :destination => @destination)
          
          @group_to_merge.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))
          @group_to_merge.users.create!(User.make_unsaved.attributes.merge(:password => 'password'))

          visit("/group/#{@group.id}")
        end

        it "should have a button" do
          page.should have_button("merge groups")
        end

        it "should have a select field" do
          page.should have_select("merge[group_id]")
        end

        it "merges selected group into displayed group" do
           members_in_group_to_merge = @group_to_merge.users.length
           members_in_group = @group.users.length
           expected_members = (members_in_group +
                                 members_in_group_to_merge )
          page.select(@group_to_merge.name, :from => "merge[group_id]")
          click_on('merge groups')

          # returns to same page
          current_path.should == "/group/#{@group.id}"
          save_and_open_page
          page.should have_css('.badge .members', :text => expected_members.to_s)
          
        end
      end
      context "when visiting a group" do
        before do
          visit("/group/#{@group.id}")
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
