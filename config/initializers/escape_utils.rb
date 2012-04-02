# workaround to get rid of rack warning when upgrading Capybara (1.1.2)
# rack-1.2.5/lib/rack/utils.rb:16: warning: regexp match /.../n against to UTF-8 string
# http://crimpycode.brennonbortz.com/?p=42

module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end