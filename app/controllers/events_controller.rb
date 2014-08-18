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

  def by_country
    @events_by_day = []
    @days = []
    number_of_days = 500
    number_of_days.times do |number_of|
      events = Event.where(:country => params[:country], :event_date => number_of.days.ago.to_date)
      @events_by_day << events.count
      @days << number_of.days.ago.to_date.strftime("%m/%d/%Y")
    end
    puts @days.inspect
  end
end
