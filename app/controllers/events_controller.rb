require 'csv'
class EventsController < ApplicationController
  def index
    @events = Event.all

    # @map_url = "http://maps.googleapis.com/maps/api/staticmap?size=600x300&maptype=roadmap>"
    @events.each do |event|
      # @map_url += event.event_location
      @test_array = [65, 59, 80, 81, 56, 55, 40]
    end

    @event_locations = []
    @events.each do |event| 
      @event_locations << {lat: event.latitude, lng: event.longitude, count: 1}
    end
    @event_locations = @event_locations.to_json
  end

  def show
    @event = Event.find_by(:id => params[:id])

    @map_url = "http://maps.googleapis.com/maps/api/staticmap?zoom=4&size=300x280&maptype=roadmap>#{@event.event_location}"
    @test_array = [65, 59, 80, 81, 56, 55, 40]
  end

  def by_country
    @events_by_day = []
    @days = []
    number_of_days = 500
    number_of_days.times do |number_of|
      events = Event.where(:country => params[:country], :event_date => number_of.days.ago.to_date)
      @events_by_day << events.count
      @days << number_of.days.ago.to_date.strftime("%m/%d/%Y")
    end
  end

  def by_actor
  end

  def new
  end

  def create
  end

  def upload
  end

  def import
    @new_events = params[:spreadsheet_as_csv]
    CSV.foreach(@new_events.path, :headers => true) do |row|
      Event.create(:event_date => row['EVENT_DATE'], 
                   :event_type => row['EVENT_TYPE'], 
                   :actor1 => row['ACTOR1'], 
                   :actor2 => row['ACTOR2'], 
                   :year => row['YEAR'].to_i, 
                   :country => row['COUNTRY'], 
                   :total_fatalities => row['TOTAL_FATALITIES'].to_i,
                   :latitude => BigDecimal(row['LATITUDE']),
                   :longitude => BigDecimal(row['LONGITUDE']), 
                   :source => row['SOURCE'], 
                   :notes => row['NOTES'], 
                   :interaction => row['INTERACTION'].to_i)
    end
  end

end
