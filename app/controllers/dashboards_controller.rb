class DashboardsController < ApplicationController

  def by_date
    @dashboard = Dashboard.new(number_of_days: 60)
    @days = @dashboard.dates
    @all_events_by_day = @dashboard.all_events_by_day.to_json
    @all_fatalities_by_day = @dashboard.all_fatalities_by_day.to_json
    @types_in_past_days = @dashboard.count_by_type
    @actors_in_past_days = @dashboard.count_by_actors
    @actor_chart_array = assign_colors_for_circle_chart(@actors_in_past_days, colors)
    @type_chart_array = assign_colors_for_circle_chart(@types_in_past_days, colors)
    @event_locations = @dashboard.locations.to_json
  end

  def by_country
    @country =  params[:country]

    @events_by_day = []
    @days = []
    @types_in_past_days = {}
    @actors_in_past_days = {}
    @fatalities_by_day = []

    number_of_days = 240
    number_of_days.times do |number_of|
      events = Event.where(:country => params[:country], :event_date => number_of.days.ago.to_date)

      total_fatalities = 0

      events.each do |event|
        if @types_in_past_days.include?(event.event_type)
          @types_in_past_days[event.event_type] += 1
        else
          @types_in_past_days.merge!({ event.event_type => 1})
        end

        if @actors_in_past_days.include?(event.actor1)
          @actors_in_past_days[event.actor1] += 1
        else
          @actors_in_past_days.merge!({ event.actor1 => 1})
        end

        if @actors_in_past_days.include?(event.actor2)
          @actors_in_past_days[event.actor2] += 2
        else
          @actors_in_past_days.merge!({ event.actor2 => 1})
        end

        total_fatalities += event.total_fatalities
      end

      @events_by_day << events.count
      @fatalities_by_day << total_fatalities
      @days << number_of.days.ago.to_date.strftime("%m/%d/%Y")
    end

    @events_by_day = @events_by_day.reverse
    @days = @days.reverse
    @count = 0

    @each_month = []
    months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @days.each do |day_label|
      if day_label =~ /[0-9]\/01\/[0-9]/
        date = day_label.split("/")
        @each_month << "#{months[date[0].to_i]} #{date[1]}, #{date[2]}"
      else
        @each_month << ""
      end
    end

    @actor_chart_array = assign_colors_for_circle_chart(@actors_in_past_days, colors)

    @type_chart_array = assign_colors_for_circle_chart(@types_in_past_days, colors)

    @fatalities_by_day = @fatalities_by_day.reverse.to_json

  end

  def by_actor
    @actor =  params[:actor]

    @events_by_day = []
    @days = []
    @types_in_past_days = {}
    @fatalities_by_day = []

    number_of_days = 240
    number_of_days.times do |number_of|

      events = (Event.where(:actor1 => params[:actor], :event_date => number_of.days.ago.to_date) + Event.where(:actor2 => params[:actor], :event_date => number_of.days.ago.to_date)).uniq.compact

      total_fatalities = 0

      events.each do |event|
        if @types_in_past_days.include?(event.event_type)
          @types_in_past_days[event.event_type] += 1
        else
          @types_in_past_days.merge!({ event.event_type => 1})
        end

        total_fatalities += event.total_fatalities
      end

      @events_by_day << events.count
      @fatalities_by_day << total_fatalities
      @days << number_of.days.ago.to_date.strftime("%m/%d/%Y")
    end
    @events_by_day = @events_by_day.reverse
    @days = @days.reverse
    @count = 0

    @each_month = []
    months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @days.each do |day_label|
      if day_label =~ /[0-9]\/01\/[0-9]/
        date = day_label.split("/")
        @each_month << "#{months[date[0].to_i]} #{date[1]}, #{date[2]}"
      else
        @each_month << ""
      end
    end

    @type_chart_array = assign_colors_for_circle_chart(@types_in_past_days, colors)

    @activity_score = (@events_by_day.sum.to_f / @days.length.to_f).round(4)
    @fatality_score = (@fatalities_by_day.sum.to_f / @events_by_day.sum.to_f).round(4)
    @fatalities_by_day = @fatalities_by_day.reverse.to_json
  end

end
