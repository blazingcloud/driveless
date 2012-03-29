require 'spec_helper'
describe ResultsController do
  include Devise::TestHelpers
  context "#csv" do
    it "sends a file" do
      sign_in User.make(:admin => true)
      filename = './tmp/driveless-results-2012Y-09m-25d-1715.csv'
      # send_file expects an existing file
      `touch #{Rails.root}/#{filename}`
      stub(Time).now.stub!.strftime('%YY-%mm-%dd-%H%M') {"2012Y-09m-25d-1715"}
      mock(Result).generate_individuals_csv(filename)
      get :csv
      response.should be_ok
      # get rid of temp file
      `rm -f #{Rails.root}/#{filename}`
    end
  end
end
