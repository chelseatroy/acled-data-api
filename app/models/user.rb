class User < ActiveRecord::Base

  before_create :generate_api_key

  def generate_api_key
    begin
      self.api_key = SecureRandom.urlsafe_base64(32)
    end while User.exists?(api_key: self.api_key)
  end
  
end
