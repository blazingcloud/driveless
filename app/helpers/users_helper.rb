module UsersHelper
  # TODO: Maybe move this method to some library as it seems too heavy for a helper
  def google_chart_image_url_for_user_since(type, user, date)
    # Default limit dates inverted on purpose
    first_date = Date.current
    last_date  = date.to_date

    # Autoinitializable nested hash
    graph = Hash.new { |hash, key| hash[key] = {} }

    # Get graphicable trips aggregated data
    user.trips.graphicable_since(date).each do |trip|
      graph[trip.mode_name][trip.made_at] = trip.distance_sum.to_i

      first_date        = [first_date, trip.made_at].min
      last_date         = [last_date, trip.made_at].max
    end

    # Gchart expects data to be sent as a nested array
    # where each inner array has to have the same size
    # so we need a value for each date even if no trip
    # was registered for that mode on that date.
    modes = graph.keys.sort
    all_dates = (first_date..last_date).to_a
    data = modes.map do |mode|
      all_dates.map {|date| graph[mode][date] || 0}
    end

    # TODO: figure out a list of better colors
    colors = ['FF0000', '00FF00', '0000FF', 'FFFF00', '00FFFF']

    # Finally return the graph url from the given data
    Gchart.send(type,
      :axis_with_labels => ['x'],
      :axis_labels      => [all_dates],
      :legend           => modes,
      :data             => data,
      :bar_colors       => colors
    )
  end
end
