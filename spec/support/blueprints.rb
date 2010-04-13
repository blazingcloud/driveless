require 'machinist/active_record'
require 'sham'

Spec::Runner.configure do |config|
  config.before(:all)  { Sham.reset(:before_all) }
  config.before(:each) { Sham.reset(:before_each) }
end
