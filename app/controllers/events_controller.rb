require 'csv'
class EventsController < ApplicationController

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

end



