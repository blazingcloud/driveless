require 'spec_helper'

describe AuthenticationsController do
  include Devise::TestHelpers
  let(:env) do
    {'omniauth.auth'  => {}}
  end
  before do
    stub(request).env {env}
  end
  context "when logged out" do
    context "with a new facebook connect request" do
      context "without an exsiting user for the connect request" do
        let(:new_user) do
          User.make
        end
        it "should redirect to the profile edit url" do

          stub(controller).current_user {nil}
          stub(User).connect_via_omniauth {new_user}

          mock(controller).sign_in(new_user)

          post :create
          response.should redirect_to('/account/edit')
        end
      end
    end
  end
end

