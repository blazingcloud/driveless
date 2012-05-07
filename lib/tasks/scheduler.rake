desc "Heroku Scheduler needs to Recalculate results from the drive less challenge"
task :recalculate_results => :environment do
  puts "Results being generated...."
  Result.recalculate!
  puts "...bing done!"

  puts ""
  puts ""

  puts "Writing out Raw Report" 
  filename = ResultsController::RAW_RESULT_FILE
  Result.generate_individuals_raw_data_csv(filename)
  puts "...bing done!"
end
