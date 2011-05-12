class Result

  def user_results
    @user_results ||= User.includes(:trips, :community).all.map do |user| 
      calculate_stats_for_user(user)
    end.compact
  end

  def modes
    @modes ||= Mode.all
  end

  def earth_day
    @earth_day ||= Date.new(Date.today.year, 4, 22)
  end

  def calculate_stats_for_user(user)
    return nil unless user.days_logged >= 5
    result = { :user => user, :days_logged => user.days_logged }
    modes.each do | mode |
      mode_mileage = user.trips.qualifying.
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
    user.trips.qualifying.each do |trip|
      if trip.mode.green?
        result[:total_green_miles] += trip.distance.to_f
        result[:total_green_trips] += 1
        result[:total_green_shopping_trips] +=1 if trip.shopping?
      end
      result[:total_miles] += trip.distance.to_f
      result[:total_lbs_co2_saved] += trip.lbs_co2_saved.to_f
    end
    return nil if result[:total_miles] == 0
    result[:actual_pct_green] = result[:total_green_miles] / result[:total_miles] * 100.0
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

  def generate_groups_csv(path_to_file)
    groups = Group.includes(:users).all.select { |group| group.qualified_for_current_challenge? }
    groups.sort! { |a, b| b.lbs_co2_saved <=> a.lbs_co2_saved }
    headers = [
      "Group ID",
      "Group Name",
      "Members",
      "Category",
      "Community",
      "Pounds CO2 saved",
      "Total miles"
    ]

    FasterCSV.open(path_to_file, "w") do |csv|
      csv << headers
      groups.each do |group|
        group.instance_eval do
          csv << [id, name, qualified_users.count, category_name, owner.try(:community).try(:name), lbs_co2_saved, total_miles]
        end
      end
    end
    path_to_file
  end


  def generate_individuals_raw_data_csv(path_to_file)
    headers = [
      "ID",
      "Name",
      "Email",
      "Address",
      "City",
      "Parent?",
      "Community",
      "Car Miles",
      "Small EV Miles",
      "Carpool Miles",
      "Train Miles",
      "Bus Miles",
      "Walk Miles",
      "Bike Miles",
      "Total Miles",
      "Total Green Miles",
      "Total Green Trips",
      "Total Green Shopping Trips",
      "Baseline % Green",
      "Actual % Green",
      "% Improvement",
      "Pounds CO2 Saved Per Mile",
      "Total Pounds CO2 Saved",
      "Days Logged"
    ]

    FasterCSV.open(path_to_file, "w") do |csv|
      csv << headers
      user_results.each do |res|

        csv << res[:user].instance_eval do
          [
            id,
            name,
            email,
            address,
            city,
            is_parent? ? "parent" : ""
          ]
        end +
          [
            :community_name,
            :"drove car alone_mileage",
            :"small electric vehicle_mileage",
            :carpool_mileage,
            :train_mileage,
            :bus_mileage,
            :walk_mileage,
            :bike_mileage,
            :total_miles,
            :total_green_miles,
            :total_green_trips,
            :total_green_shopping_trips,
            :baseline_pct_green,
            :actual_pct_green,
            :pct_improvement,
            :lbs_co2_saved_per_mile, 
            :total_lbs_co2_saved,
            :days_logged
        ].map {|attr| res[attr]}
      end
    end
    path_to_file
  end

  def generate_individuals_csv(path_to_file)

    header = [
      "Number of trips",
      "Result",
      "Total green miles",
      "Total miles",
      "Pounds of CO2 saved",
      "Days logged",
      "username",
      "Name",
      "Address",
      "City",
      "Community",
      "email",
      "Parent?"
    ]

    add_to_csv = lambda do |csv, user_result, attribute|

      unless user_results.nil?
        csv << [
          user_result[:total_green_trips],
          user_result[attribute],
          user_result[:total_green_miles],
          user_result[:total_miles],
          user_result[:total_lbs_co2_saved],
          user_result[:days_logged],
          user_result[:user].username,
          user_result[:user].name,
          user_result[:user].address,
          user_result[:user].city,
          user_result[:community_name],
          user_result[:user].email,
          user_result[:user].is_parent? ? "parent" : ""
        ]
      end
    end

    FasterCSV.open(path_to_file, "w") do |csv|

      csv << ["Most Green Miles for All Users"]
      csv << header
      users_by_mileage[0..4].each { |user_result| add_to_csv.call(csv, user_result, :total_green_miles) }
      Mode.green.each do |mode|
        csv << [""]
        csv << ["Most Green Miles for Users: #{mode.name}"]
        csv << header
        users_by_mileage(:mode => mode)[0..4].each { |user_result| add_to_csv.call(csv, user_result, :"#{mode.name.downcase}_mileage") }
      end

      csv << [""]
      csv << [ "Most Green Trips" ]
      csv << header
      users_by_total_green_trips[0..4].each { |user_result| add_to_csv.call(csv, user_result, :total_green_trips) }

      csv << [""]
      csv << [ "Most Green Shopping Trips" ]
      csv << header
      users_by_total_green_shopping_trips[0..4].each { |user_result| add_to_csv.call(csv, user_result, :total_green_shopping_trips) }

      csv << [""]
      csv << ["Greenest Travel"]
      csv << header
      users_by_greenest_travel[0..4].each { |user_result| add_to_csv.call(csv, user_result, :lbs_co2_saved_per_mile) }

      csv << [""]
      csv << ["Most Improved vs. Baseline"]
      csv << header
      users_by_most_improved_over_baseline[0..4].each { |user_result| add_to_csv.call(csv, user_result, :pct_improvement) }

      Community.all.each do |community|
        csv << [""]
        csv << ["Most Green Miles for Users in #{community.name}"]
        csv << header
        users_by_mileage(:community => community)[0..4].each { |user_result| add_to_csv.call(csv, user_result, :total_green_miles) }
        Mode.green.each do |mode|
          csv << [""]
          csv << ["Most Green Miles for Users in #{community.name}: #{mode.name}"]
          csv << header
          users_by_mileage(:community => community, :mode => mode)[0..4].
            each { |user_result| add_to_csv.call(csv, user_result, :"#{mode.name.downcase}_mileage") }
        end

        csv << [""]
        csv << [ "Most Green Trips in #{community.name}" ]
        csv << header
        users_by_total_green_trips_for(community)[0..4].each { |user_result| add_to_csv.call(csv, user_result, :total_green_trips) }

        csv << [""]
        csv << [ "Most Green Shopping Trips in #{community.name}" ]
        csv << header
        users_by_total_green_shopping_trips_for(community)[0..4].each { |user_result| add_to_csv.call(csv, user_result, :total_green_shopping_trips) }

        csv << [""]
        csv << ["Greenest Travel in #{community.name}"]
        csv << header
        users_by_greenest_travel_for(community)[0..4].each { |user_result| add_to_csv.call(csv, user_result, :lbs_co2_saved_per_mile) }

        csv << [""]
        csv << ["Most Improved vs. Baseline in #{community.name}"]
        csv << header
        users_by_most_improved_over_baseline_for(community)[0..4].each { |user_result| add_to_csv.call(csv, user_result, :pct_improvement) }

      end
    end
    path_to_file
  end

  def self.bench
    start = Time.now
    100.times do
      yield
    end
    puts "Time: #{Time.now - start}"
  end
  
end

