require 'httparty'
require 'kele/roadmap'
require 'json'

class Kele
  include HTTParty
  include Roadmap
  #base_uri "https://www.bloc.io/api/v1/sessions"

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    raise "invalid email/pass" if response.code != 200
    @auth_token = response["auth_token"]
  end

  def get_me
    url = "https://www.bloc.io/api/v1/users/me"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    body = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    url = 'https://www.bloc.io/api/v1/mentors/'+(mentor_id.to_s)+'/student_availability'
    response = self.class.get(url, headers:{ "authorization" => @auth_token} )
    body = JSON.parse(response.body)
    body.find_all {|x| x['booked'] == nil}.map {|x| x["starts_at"]}
  end

  #moved get_roadfmap and get_checkpoint to kele/roadmap.rb

=begin
  def get_roadmap(roadmap_id)
    url = 'https://www.bloc.io/api/v1/roadmaps/' + (roadmap_id.to_s)
    response = self.class.get(url, headers: {"authorization" => @auth_token})
    body = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    url = 'https://www.bloc.io/api/v1/checkpoints/' + (checkpoint_id.to_s)
    response = self.class.get(url, headers: {"authorization" => @auth_token})
    body = JSON.parse(response.body)
  end
=end
  def get_messages(arg = nil) #body:{page:...} means that when it is sending GET request, it is sending page number in body
    url = 'https://www.bloc.io/api/v1/message_threads'
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    body = JSON.parse(response.body)
    if arg == nil
      pages = (1..response["count"]).map do |n| #This displays everything
        self.class.get(url, body: { page: n }, headers: { "authorization" => @auth_token })
      end
    else
        self.class.get(url, body: { page: arg}, headers: { "authorization" => @auth_token })
    end
  end

  #if I do (1..2).map, I get 20 "pages" and 2 "counts". If I do (1..3), 30 pages and 3 counts.
  #I have 52 counts. Meaning there are 52 * 10 = 520 messages.
end
