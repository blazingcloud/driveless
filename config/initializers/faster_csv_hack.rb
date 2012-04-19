if Object.const_defined? 'FasterCSV'
  CSV = FasterCSV
else
  require 'csv'
end

