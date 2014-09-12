require 'csv'
class EventsController < ApplicationController

  def admin
  end

  def dashboard
    @events = Event.all

    @all_events_by_day = []
    @all_fatalities_by_day = []
    @days = []
    @actors_in_past_days = {}
    @types_in_past_days = {}

    number_of_days = 60

    number_of_days.times do |number_of|

      events = Event.for(Date.today - number_of.days)

      total_fatalities = 0

      events.each do |event|
        @types_in_past_days.merge!(Event.types_from(events))
        @actors_in_past_days.merge!(Event.actors_from(events))
        total_fatalities += event.total_fatalities
      end

      @all_events_by_day << events.count
      @all_fatalities_by_day << total_fatalities
      @days << number_of.days.ago.to_date.strftime("%m/%d/%Y")
    end

    # Line chart of fatalities, events by day created in above

    # Pie chart of all actors; values represent incidents per actor
    @actor_chart_array = assign_colors_for_circle_chart(@actors_in_past_days, colors)

    # Pie chart of all event types; values represent occurences of each event
    @type_chart_array = assign_colors_for_circle_chart(@types_in_past_days, colors)

    @days = @days.reverse
    @all_events_by_day = @all_events_by_day.reverse.to_json
    @all_fatalities_by_day = @all_fatalities_by_day.reverse.to_json

    # Heatmap of event locations; color depth is # events per location
    @event_locations = []
    @events.each do |event|
      @event_locations << {lat: event.latitude, lng: event.longitude, count: 1}
    end
    @event_locations = @event_locations.to_json

  end

  def index
    @events = Event.all
  end

  def show
    @event = Event.find_by(:id => params[:id])

    @map_url = "http://maps.googleapis.com/maps/api/staticmap?zoom=4&size=300x280&maptype=roadmap>#{@event.event_location}"
  end

  def countries
    @events = Event.all
    @countries = Event.uniq.pluck(:country)
  end

  def actors
    @events = Event.all

    actor1s = Event.uniq.pluck(:actor1).compact.map(&:capitalize)
    actor2s = Event.uniq.pluck(:actor2).compact.map(&:capitalize)
    @actors = (actor1s+actor2s).uniq.sort
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

  def new
    @event = Event.new
  end

  def create
    #TODO: Make date adding solution more robust
    event_date_as_array = event_params[:event_date].split("/")
    event_date = Date.new(event_date_as_array[2].to_i, event_date_as_array[0].to_i, event_date_as_array[1].to_i)
    Event.create(event_params.merge(:event_date => event_date))
    flash[:notice] = "Event created."
    redirect_to root_path
  end

  def upload
  end

  def edit
    @event = Event.find_by(:id => params[:id])
  end

  def update
    @event = Event.find_by(:id => params[:id])
    @event.update(event_params)
    redirect_to admin_dashboard_path
  end

  def destroy
    @event = Event.find_by(:id => params[:id])
    @event.destroy
  end

  def import
    @new_events = params[:spreadsheet_as_csv]
    count = 0
    CSV.foreach(@new_events.path, :headers => true) do |row|
      count += 1
      begin
        Event.create(:event_date => row['EVENT_DATE'],
                   :event_type => row['EVENT_TYPE'],
                   :actor1 => row['ACTOR1'],
                   :actor2 => row['ACTOR2'],
                   :year => row['YEAR'].to_i,
                   :country => row['COUNTRY'],
                   :total_fatalities => row['TOTAL_FATALITIES'].to_i,
                   :latitude => row['LATITUDE'],
                   :longitude => BigDecimal(row['LONGITUDE']),
                   :source => BigDecimal(row['SOURCE']),
                   :notes => row['NOTES'],
                   :interaction => row['INTERACTION'].to_i)
      rescue
        puts "MALFORMED ROW: #{count}"
      end
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



