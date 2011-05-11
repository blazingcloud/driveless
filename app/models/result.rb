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
    user.trips.each do |trip|
      if trip.mode.green?
        result[:total_green_miles] += trip.distance.to_f
        result[:total_green_trips] += 1
      end
      result[:total_miles] += trip.distance.to_f
    end
    result[:actual_pct_green] = result[:total_miles] == 0 ? 0 : result[:total_green_miles] / result[:total_miles]
    result[:pct_improvement] = result[:actual_pct_green] - result[:baseline_pct_green]
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

  def users_by_green_trips
    sort_by_green_trips(user_results)
  end

  def users_by_green_trips_for(community)
    results = filter_by_community(community)
    sort_by_green_trips(results)
  end

  def filter_by_community(community)
    user_results.select {|res| res[:community_name] == community.name}
  end

  def sort_by_green_trips(results)
    results.sort {|a,b| b[:total_green_trips] <=> a[:total_green_trips]}
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

  def self.bench
    start = Time.now
    100.times do
      yield
    end
    puts "Time: #{Time.now - start}"
  end
  
end

