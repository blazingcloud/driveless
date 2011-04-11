# Facebooker causes bad things to happen when using
# Rack 1.1.x (which we are because it's required by Rails 2.3.11)
#
# This solution comes from:
# https://gist.github.com/430807
#
ActionController::Integration::Session.class_eval do
  def generic_url_rewriter
    env = {
      'REQUEST_METHOD' => "GET",
      'QUERY_STRING'   => "",
      "REQUEST_URI"    => "/",
      "HTTP_HOST"      => host,
      "SERVER_PORT"    => https? ? "443" : "80",
      "HTTPS"          => https? ? "on" : "off",
      "rack.input"     => "wtf"
    }
    ActionController::UrlRewriter.new(ActionController::Request.new(env), {})
  end
end

