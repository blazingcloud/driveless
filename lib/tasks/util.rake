desc "recalculate all users green miles" 
task :green_user_recalc => :environment do
 ids =  User.connection.select_values("select id from users")
 ids.each do |id|
  User.find(id).update_green_miles
 end
end
