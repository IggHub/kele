require 'httparty'

class Kele
  include HTTParty
  #base_uri "https://www.bloc.io/api/v1/sessions"

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    if StandardError
      "error"
    end

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

end
