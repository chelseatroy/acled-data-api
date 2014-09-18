class Event < ActiveRecord::Base

  def self.types_from(events)
    events.inject({}) do |hash, event|
      hash[event.event_type] ||= 0
      hash[event.event_type] += 1
      hash
    end
  end

  def self.actors_from(events)
    events.inject({}) do |hash, event|
      hash[event.actor1] ||= 0
      hash[event.actor1] += 1
      hash[event.actor2.to_s] ||= 0
      hash[event.actor2.to_s] += 1
      hash
    end
  end

  def self.for(date)
    raise("No start date provided") unless date
    Event.where(event_date: date)
  end

  # TODO We need a date validator!
  def self.between(start_date, end_date=nil)
    end_date ||= Date.today
    raise("No start date provided") unless start_date
    raise("Invalid start date") unless Date.parse(start_date.to_s)
    raise("Invalid end date") unless Date.parse(end_date.to_s)
    Event.where(event_date: start_date..end_date)
  end

  def lat_lng
    {lat: self.latitude, lng: self.longitude, count: 1}
  end

  def event_location
    location = "&markers=color:blue%7C#{self.latitude},#{self.longitude}"
  end

end
