# TODO rename this?
class Dashboard

  include PoroPlus

  attr_accessor :number_of_days, :locations, :country

  def actors
    statistics.map(&:actors).map(&:flatten).flatten.uniq
  end

  def actors_by_day
    type_counts = statistics.map{ |stat| stat.types.count }
    dates.zip(type_counts)
  end

  def all_events_by_day
    statistics.map(&:events_count)
  end

  def all_fatalities_by_day
    statistics.map(&:fatalities_count)
  end

  def count_by_actors
    actors.inject({}) do |hash, actor|
      hash[actor] = Event.where("actor1 = ? || actor2 = ?", actor, actor).count
      hash
    end
  end

  def count_by_type
    types.inject({}) do |hash, event_type|
      hash[event_type] = Event.where("event_type = ?", event_type).count
      hash
    end
  end

  def types
    statistics.map(&:types).map(&:flatten).flatten.uniq
  end

  def dates
    @dates ||= ((Date.today - (number_of_days - 1).days)..Date.today).map do |date|
      date.strftime("%Y/%m/%d")
    end
  end

  def events_for_date(date)
    events = Event.for(Date.parse(date))
    events = events.for_country(self.country) if self.country.present?
    events
  end

  def statistics
    @statistics ||= dates.map do |date|
      events = events_for_date(date)
      stat = Statistic.new(
        events_count: events.count,
        fatalities_count: events.map(&:total_fatalities).sum,
        actors: Event.actors_from(events),
        types: Event.types_from(events)
      )
    end
  end

  def locations
    Event.all.map(&:lat_lng)
  end

  class Statistic
    include PoroPlus
    attr_accessor :events_count, :types, :actors, :fatalities_count
  end

end
