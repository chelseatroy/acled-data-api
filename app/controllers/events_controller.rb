class EventsController < ApplicationController

  def index
    @events = Event.all
    respond_with(@events)
  end

  def create
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def show
    @event = Event.find_by(:id => params[:id])
    respond_with(@event)
  end

  private

  def event_params
    return params.require(:event).permit(:event_date, :year, :event_type, :actor1, :actor2, :interaction, :country, :source, :notes, :total_fatalities, :latitude, :longitude)
  end
end
