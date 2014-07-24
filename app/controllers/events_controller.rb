class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def create
    @event = Event.new(event_params)
    @event.save
  end

  def show
    @event = Event.find_by(:id => params[:id])
  end

  def update
    @event = Event.find_by(:id => params[:id])
    @event.update(event_params)
  end

  def destroy
    @event = Event.find_by(:id => params[:id])
    @event.destroy
  end

  private

  def event_params
    return params.require(:event).permit(:event_date, :year, :event_type, :actor1, :actor2, :interaction, :country, :source, :notes, :total_fatalities, :latitude, :longitude)
  end
end
