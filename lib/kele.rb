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
    #body["current_enrollment"]["mentor_id"]
  end

  def get_mentor_availability(mentor_id = 2290632)
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
    body = JSON.parse(response.body) #does it return a JSON?
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
=begin
  def create_message(user_id = 2319446, recipient_id = 2290632, token = nil, subject, stripped)
    url = 'https://www.bloc.io/api/v1/messages'
    response = self.class.post(url, body: {"user_id" => user_id, "recipient_id" => recipient_id, "token" => token, "subject" => subject, "stripped" => stripped}, headers:{ "authorization" => @auth_token})
    body = JSON.parse(response.body)
  end
=end

  def create_message(user_id, recipient_id, subject, stripped)
    url = 'https://www.bloc.io/api/v1/messages'
    self.class.post(url, body: {user_id: user_id, recipient_id: recipient_id, token: nil, subject: subject, stripped: stripped}, headers: { "authorization" => @auth_token })
   end

   def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
     url = 'https://www.bloc.io/api/v1/checkpoint_submissions'
     response = self.class.post(url, body: {"assignment_branch" => assignment_branch, "assignment_commit_link" => assignment_commit_link, "checkpoint_id" => checkpoint_id, "comment" => comment, "enrollment_id" => enrollment_id}, headers: {"authorization" => @auth_token})
     body = JSON.parse(response.body)
   end
   
end
