require 'httparty'
require 'kele/errors'

class Kele
  include HTTParty
  #base_uri "https://www.bloc.io/api/v1/sessions"

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    raise "invalid email/pass" if response.code != 200
=begin  case response.code
    when 200
      puts "All good!"
    when 404
      puts "O noes not found!"
    when 500...600
      puts "ZOMG ERROR #{response.code}"
    else
      puts "Error dodged"
  end
=end
    @auth_token = response["auth_token"]
  end

  def get_me
    url = "https://www.bloc.io/api/v1/users/me"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
  end

end
