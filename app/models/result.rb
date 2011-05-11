class Result

  def user_results
    @user_results ||= User.includes(:trips).all.map do |user| 
      calculate_stats_for_user(user)
    end.compact
  end

  def modes
    @modes ||= Mode.all
  end

  def calculate_stats_for_user(user)
    return nil unless user.trips.size >= 5
    result = { :user => user }
    modes.each do | mode |
      mode_mileage = user.trips.
        select {|trip| trip.mode_id == mode.id}.
        sum {|trip| trip.distance.to_f}
      result[:"#{mode.name.downcase}_mileage"] = mode_mileage || 0.0
    end
    result[:community_name] = user.community.try(:name)
    result[:baseline_pct_green] = user.baseline.percent_green
    result[:total_green_miles] = 0
    result[:total_miles] = 0
    result[:total_green_trips] = 0
    result[:total_green_shopping_trips] = 0
    result[:total_lbs_co2_saved] = 0
    user.trips.each do |trip|
      if trip.mode.green?
        result[:total_green_miles] += trip.distance.to_f
        result[:total_green_trips] += 1
        result[:total_green_shopping_trips] +=1 if trip.shopping?
      end
      result[:total_miles] += trip.distance.to_f
      result[:total_lbs_co2_saved] += trip.lbs_co2_saved.to_f
    end
    result[:actual_pct_green] = result[:total_miles] == 0 ? 0 : result[:total_green_miles] / result[:total_miles]
    result[:pct_improvement] = result[:actual_pct_green] - result[:baseline_pct_green]
    result[:lbs_co2_saved_per_mile] = result[:total_lbs_co2_saved] / result[:total_miles]
    result
  end

  def users_by_mileage(options = {})
    results = user_results
    if community = options[:community]
      results = results.select {|res| res[:community_name] == community.name}
    end

    attr = options[:mode] ? :"#{options[:mode].name.downcase}_mileage" : :total_green_miles
    results = results.sort do |a, b|
      b[attr] <=> a[attr]
    end.reject {|res| res[attr] == 0}
  end

  def users_by_mileage_by_community_by_mode
    Community.all.each do |community|
      Mode.all.each do |mode|
        next unless mode.green?
        puts users_by_mileage(:mode => mode, :community => community).map {|res| res[:user].id}.join(", ")
        #puts users_by_mileage(:mode => mode, :community => community).map {|res| res[:user].id}[0..4].join(", ")
      end
    end
  end

  def users_by_total_green_trips
    sort_by(:total_green_trips, user_results)
  end

  def users_by_total_green_trips_for(community)
    filtered_results = filter_by_community(community)
    sort_by(:total_green_trips, filtered_results)
  end

  def users_by_total_green_shopping_trips
    sort_by(:total_green_shopping_trips, user_results)
  end

  def users_by_total_green_shopping_trips_for(community)
    filtered_results = filter_by_community(community)
    sort_by(:total_green_shopping_trips, filtered_results)
  end

  def users_by_greenest_travel
    sort_by(:lbs_co2_saved_per_mile, user_results)
  end

  def users_by_greenest_travel_for(community)
    filtered_results = filter_by_community(community)
    sort_by(:lbs_co2_saved_per_mile, filtered_results)
  end

  def users_by_most_improved_over_baseline
    sort_by(:pct_improvement, user_results)
  end

  def users_by_most_improved_over_baseline_for(community)
    filtered_results = filter_by_community(community)
    sort_by(:pct_improvement, filtered_results)
  end

  def filter_by_community(community)
    user_results.select {|res| res[:community_name] == community.name}
  end

  def sort_by(field_name, results = nil)
    results ||= user_results
    results.sort {|a,b| b[field_name] <=> a[field_name]}
  end

  # ==== Groups

  def calculate_stats_for_group(group)
  end

  def group_stats

  end

  # ==== CSV

  def generate_csv(path_to_file)

  FasterCSV.open(path_to_file, "w") do |csv|

    csv << ["Users by green mileage"]
    # need to have a version of filtered by community
    csv << ["another", "row"]
    # ...
  end
  
    File.open(path_to_file, 'w+') do |f|
      
    end
  end

  def self.bench
    start = Time.now
    100.times do
      yield
    end
    puts "Time: #{Time.now - start}"
  end
  
end

