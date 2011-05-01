require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  before do
    @user = Factory(:user)
  end

  context "when not logged in" do

    it 'redirects to home page' do
      get :index
      response.should redirect_to(new_user_session_path)
    end
  end
  
  context "when logged in" do
    before do
      sign_in @user
    end

    shared_examples_for "finding user" do
      it "assigns user" do
        assigns(:user).should == @user
      end
    end

    describe "GET index" do
      it "assigns all users as @users" do
        get :index
        assigns(:users).should_not be_nil
      end
    end

    describe "GET show" do
      before do
        get :show, :id => @user.to_param
      end
      it_should_behave_like "finding user"
    end

    describe "GET new" do
      it "assigns a new user as user" do
        get :new
        assigns(:user).should_not be_nil
      end
    end

    describe "GET edit" do
      before do
        get :edit, :id => @user.to_param
      end
      it_should_behave_like "finding user"
    end

    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => @user.to_param, :user => {:first_name => 'NNNNN'}
        end

        it "updates the requested user" do
          @user.reload.first_name.should == "NNNNN"
        end

        it_should_behave_like "finding user"

        it "redirects to the user" do
          put :update, :id => @user.to_param, :user => {:first_name => 'Peter'}
          response.should redirect_to(user_url(@user))
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => @user.to_param, :user => {:first_name => ''}
        end

        it_should_behave_like "finding user"

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end

    end
  end
end
