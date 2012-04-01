require 'spec_helper'

describe 'robots.txt' do
  describe 'when hostname is not driveless-staging.heroku.com' do
    before do
      mock.instance_of(RobotsController).hostname { "my.drivelesschallenge.com" }
      visit '/robots.txt'
      @directives = page.body.split("\n").reject {|line| line.match(/^\s*#/) || line.match(/<!DOCTYPE/) }
    end

    it "should allow search engines to search site" do
      @directives.should be_blank
    end
  end

  describe "when hostname is driveless-staging.heroku.com" do
    before do
      mock.instance_of(RobotsController).hostname { "driveless-staging.heroku.com" }
      visit '/robots.txt'
      @directives = page.body.split("\n").reject {|line| line.match(/^\s*#/)}
    end

    it "should not allow search engines to search site" do
      @directives.should be_present
      @directives.should include("User-Agent: *")
      @directives.should include("Disallow: /")
    end

  end
end
