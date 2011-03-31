require 'factory_girl'

Factory.define :user do |f|
  f.email     "joe@example.com"
  f.username  "joe"
  f.name      "Joe Smith"
  f.address   "123 Main Street"
  f.city      "SF"
  f.zip       "94105"
end