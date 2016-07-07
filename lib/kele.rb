require 'httparty'

class Kele
  include HTTParty


  def initialize(email, password)
    response = self.class.post(url_endpoint("sessions"), body: {"email": email, "password": password}) #fix url_endpoint('sessions') to append the name.
    raise InvalidStudentCodeError.new() if response.code == 401
    @auth_token = response["auth_token"]
  end

  private

  url_endpoint = 'https://www.bloc.io/api/v1'
  
end
