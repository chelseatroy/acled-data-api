class EventsController < ApplicationController
  def index
    @events = Event.all

    @map_url = "http://maps.googleapis.com/maps/api/staticmap?size=600x300&maptype=roadmap>"
    @events.each do |event|
      @map_url += event.event_location
      @test_array = [65, 59, 80, 81, 56, 55, 40]
    end


  end

  def show
    @event = Event.find_by(params[:id])

    @map_url = "http://maps.googleapis.com/maps/api/staticmap?size=600x300&maptype=roadmap>#{@event.event_location}"
    @test_array = [65, 59, 80, 81, 56, 55, 40]
  end
end
