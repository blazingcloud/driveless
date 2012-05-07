class Result < ActiveRecord::Base
  has_many :mode_mileages
  belongs_to :user
  belongs_to :community

  delegate :name, :email, :username, :address, :city, :is_parent?, :to => :user

  def community_name
    community.try(:name)
  end

  scope :top_five, lambda { where(:qualified => true).limit(5) }
  scope :order_and_filter, lambda { |field| where("#{field} is not null and #{field} > 0").order("#{field} desc") }

  scope :greenest_travel, lambda { 
    top_five.
      order("lbs_co2_saved_per_mile desc, days_logged desc, total_green_trips desc").
      where("lbs_co2_saved_per_mile > 0") 
  }
  scope :greenest_travel_for, lambda { |community| greenest_travel.where(:community_id => community.id) }

  FIELDS = ActiveSupport::OrderedHash[[
    ["ID", :user_id],
    ["Name", :name],
    ["Email", :email],
    ["Username", :username],
    ["Address", :address],
    ["City", :city],
    ["Parent?", :is_parent?],
    ["Community", :community_name],
    ["Car Miles", :car_miles],
    ["Small EV Miles", :small_ev_miles],
    ["Electric Car Miles", :electric_car_miles],
    ["Carpool Miles", :carpool_miles],
    ["Train Miles", :train_miles],
    ["Bus Miles", :bus_miles],
    ["Walk Miles", :walk_miles],
    ["Bike Miles", :bike_miles],
    ["Total Miles", :total_miles],
    ["Total Green Miles", :total_green_miles],
    ["Total Green Trips", :total_green_trips],
    ["Total Green Shopping Trips", :total_green_shopping_trips],
    ["Baseline % Green", :baseline_pct_green],
    ["Actual % Green", :actual_pct_green],
    ["% Improvement", :pct_improvement],
    ["Pounds CO2 Saved Per Mile", :lbs_co2_saved_per_mile],
    ["Total Pounds CO2 Saved", :total_lbs_co2_saved],
    ["Days Logged", :days_logged]
  ]]

  HEADERS = FIELDS.keys
  FIELD_NAMES = FIELDS.values

  def self.recalculate!
    delete_all
    ModeMileage.delete_all
    @modes = Mode.all
    User.includes(:trips, :community, :baseline).each do |user|
      result = create_result_for(user)
    end
  end

  def self.modes
    @modes ||= Mode.all
  end

  def self.create_result_for(user)
    result = new(:user_id => user.id, :days_logged => user.days_logged, :qualified => user.days_logged >= 5)
    result.community_id = user.community_id
    result.baseline_pct_green = user.baseline.try(:percent_green)
    user.trips.qualifying.each do |trip|
      if trip.mode.green?
        result.total_green_miles += trip.distance.to_f
        result.total_green_trips += 1
        result.total_green_shopping_trips +=1 if trip.shopping?
      end
      result.total_miles += trip.distance.to_f
      result.total_lbs_co2_saved += trip.lbs_co2_saved.to_f
    end
    unless result.total_miles == 0
      result.actual_pct_green = result.total_green_miles / result.total_miles * 100.0
      result.lbs_co2_saved_per_mile = result.total_lbs_co2_saved / result.total_miles
      unless result.baseline_pct_green.nil?
        result.pct_improvement = result.actual_pct_green - result.baseline_pct_green
      end
    end
    result.save!
    modes.each do | mode |
      mileage = user.trips.qualifying.where(:mode_id => mode.id).sum(:distance).to_f
      result.mode_mileages.create!(:user_id => user.id, :mode_id => mode.id, :mileage => mileage, :mode_name => mode.name)
    end
    result
  end

  # ==== CSV

  def self.generate_groups_csv(path_to_file)
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

    CSV.open(path_to_file, "w") do |csv|
      csv << headers
      groups.each do |group|
        group.instance_eval do
          csv << [id, name, qualified_users.count, category_name, owner.try(:community).try(:name), lbs_co2_saved, total_miles]
        end
      end
    end
    path_to_file
  end

  def car_miles
    mode_mileages.where(:mode_name => "Drove Car Alone").first.try(:mileage)
  end

  def carpool_miles
    mode_mileages.where(:mode_name => "Carpool").first.try(:mileage)
  end

  def train_miles
    mode_mileages.where(:mode_name => "Train").first.try(:mileage)
  end

  def bus_miles
    mode_mileages.where(:mode_name => "Bus").first.try(:mileage)
  end

  def small_ev_miles
    mode_mileages.where(:mode_name => "Small Electric Vehicle").first.try(:mileage)
  end

  def electric_car_miles
    mode_mileages.where(:mode_name => "Electric Car").first.try(:mileage)
  end

  def bike_miles
    mode_mileages.where(:mode_name => "Bike").first.try(:mileage)
  end

  def walk_miles
    mode_mileages.where(:mode_name => "Walk").first.try(:mileage)
  end

  def field_values
    FIELD_NAMES.map {|field_name| self.send(field_name)}
  end

  def self.generate_individuals_raw_data_csv(path_to_file)
    CSV.open(path_to_file, "w") do |csv|
      csv << HEADERS
      all.each do |result|
        csv << result.field_values
      end
    end
    path_to_file
  end

  def self.generate_individuals_csv(path_to_file)

    CSV.open(path_to_file, "w") do |csv|

      add_to_csv = lambda do | category, results |
        csv << [""] * HEADERS.length
        csv << [category] + [""] * (HEADERS.length - 1)
        csv << HEADERS
        results.each {|result| csv << result.field_values}
      end

      add_to_csv.call("Most Green Miles for All Users", top_five.order_and_filter("total_green_miles"))
      Mode.green.each do |mode|
        add_to_csv.call("Most Green Miles for All Users: #{mode.name}", ModeMileage.top_five.where(:mode_id => mode.id).where("mileage > 0").map {|m| m.result})
      end
      add_to_csv.call("Most Green Trips", top_five.order_and_filter("total_green_trips"))
      add_to_csv.call("Most Green Shopping Trips", top_five.order_and_filter("total_green_shopping_trips"))
      add_to_csv.call("Greenest Travel", greenest_travel)
      add_to_csv.call("Most Improved vs. Baseline", top_five.order_and_filter("pct_improvement").order("days_logged desc").order("total_green_trips desc"))

      Community.all.each do |community|
        add_to_csv.call("Most Green Miles for Users in #{community.name}", top_five.where(:community_id => community.id).order_and_filter("total_green_miles"))
        Mode.green.each do |mode|
          add_to_csv.call("Most Green Miles for Users in #{community.name}: #{mode.name}", ModeMileage.top_five.where(:mode_id => mode.id).where(["mileage > 0 and results.community_id = ?", community.id]).map {|m| m.result})
        end
        add_to_csv.call("Most Green Trips in #{community.name}", top_five.where(:community_id => community.id).order_and_filter("total_green_trips"))
        add_to_csv.call("Most Green Shopping Trips in #{community.name}", top_five.where(:community_id => community.id).order_and_filter("total_green_shopping_trips"))
        add_to_csv.call("Greenest Travel in #{community.name}", greenest_travel_for(community))
        add_to_csv.call("Most Improved vs. Baseline in #{community.name}", top_five.where(:community_id => community.id).order_and_filter("pct_improvement").order("days_logged desc").order("total_green_trips desc"))
      end
    end
    path_to_file
  end

  def self.bench
    start = Time.now
    10.times do
      yield
    end
    puts "Time: #{Time.now - start}"
  end
  
end

