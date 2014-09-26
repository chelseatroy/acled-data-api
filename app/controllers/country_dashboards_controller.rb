class CountryDashboardsController < ApplicationController

  def show
    @dashboard = Dashboard.new(number_of_days: 240, country: params[:country])
    @days = @dashboard.dates
    @all_events_by_day = @dashboard.all_events_by_day.to_json
    @all_fatalities_by_day = @dashboard.all_fatalities_by_day.to_json
    @types_in_past_days = @dashboard.count_by_type
    @actors_in_past_days = @dashboard.count_by_actors
    @actor_chart_array = assign_colors_for_circle_chart(@actors_in_past_days, colors)
    @type_chart_array = assign_colors_for_circle_chart(@types_in_past_days, colors)
    @event_locations = @dashboard.locations.to_json
    @fatalities_by_day = @all_fatalities_by_day.to_json
    @country = params[:country]
    @each_month = @days.map do |day|
      date = Date.parse(day.to_s)
      date.beginning_of_month == date ? date.strftime("%b %Y") : ""
    end
  end

private

    def assign_colors_for_circle_chart(hash_of_data, colors)
      i = 0
      array_for_circle_chart = []
      hash_of_data.each {|key, value|
        i = 0 unless colors[i+1]
        array_for_circle_chart.push({value:value, color:colors[i], highlight:colors[i+1], label:key})
        i += 2
      }
      array_for_circle_chart
    end

    #I'm trying to factor the "i" stuff out of the above method
    def recycle_colors(color_index)
      #"or" used for control flow
      colors[i+1] or 0
    end

    def colors
      ["#F7464A", "#FF5A5E",
        "#46BFBD", "#5AD3D1",
        "#FDB45C", "#FFC870",
        "#0C873F", "#12E369",
        "#9D12E3", "#D98BE8",
        "#128FE3", "#3BA0E3",
        "#E0620D", "#E39C6D",
        "#E39C6D", "#F2949D",
        "#266331", "#60E679"]
    end
end




