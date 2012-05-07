require 'spec_helper'
describe ResultsController do
  include Devise::TestHelpers
  let (:timestamp) do
    "2012Y-09m-25d-1715"
  end
  describe "sending a csv file" do
    before do
      sign_in User.make(:admin => true)

      mock.proxy(controller).send_file(filename)
      #
      # do this after signin as the user needs Time object to be normal
      #
      stub(Time).now.stub!.strftime('%YY-%mm-%dd-%H%M') {timestamp}

      # send_file expects an existing file
      `touch #{Rails.root}/#{filename}`
    end

    after do
      # get rid of temp file
      `rm -f #{Rails.root}/#{filename}`
    end


    describe "#group_csv" do
      let(:filename) do
        "./tmp/driveless-group-results-#{timestamp}.csv"
      end
      it "sends a file" do
        mock(Result).generate_groups_csv(filename)
        get :group_csv
        response.should be_ok
      end
    end

    describe "#raw_csv" do
      let(:filename) do
        "./tmp/driveless-raw-individual-results-#{timestamp}.csv"
      end
      it "sends a file" do
        mock(Result).generate_individuals_raw_data_csv(filename)
        get :raw_csv
        response.should be_ok
      end
    end

    describe "#csv" do
      let(:filename) do
        "./tmp/driveless-individual-results-#{timestamp}.csv"
      end
      it "sends a file" do
        mock(Result).generate_individuals_csv(filename)
        get :csv
        response.should be_ok
      end
    end
  end
end
