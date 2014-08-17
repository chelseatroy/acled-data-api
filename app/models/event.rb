class Event < ActiveRecord::Base 

  def event_location
    location = "&markers=color:blue%7C#{self.latitude},#{self.longitude}"
  end 

end
