class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :null_session
   respond_to :json, :xml, :html

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(:email => request.headers["User-Email"], :api_key => token)
    end
   end

  private

  def event_params
    return params.require(:event).permit(:event_date, :year, :event_type, :actor1, :actor2, :interaction, :country, :source, :notes, :total_fatalities, :latitude, :longitude)
  end
end
