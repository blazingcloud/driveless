desc "Heroku Scheduler needs to Recalculate results from the drive less challenge"
task :recalculate_results => :environment do
  puts "Results being generated...."
  Result.recalculate!
  puts "...bing done!"

end
