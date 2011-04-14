class RobotsController < ApplicationController
  def robots_txt
    response.headers["Content-Type"] = "text/plain"
    if hostname == "driveless-staging.heroku.com"
      render :text => <<ROBOTS
# See http://www.robotstxt.org/wc/norobots.html for documentation on how to use the robots.txt file
#
# To ban all spiders from the entire site uncomment the next two lines:
User-Agent: *
Disallow: /
ROBOTS
    else
      render :text => ""
    end
  end

  private

  def hostname
    request.host
  end
end
