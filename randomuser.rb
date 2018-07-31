require 'sinatra'
require 'json'
require 'redis'
require 'httparty'

def user_query
  response = HTTParty.get('https://randomuser.me/api')
  name = name_query(response)
  phone = phone_query(response)

  { name: name, phone: phone }.to_json
end

def name_query(response)
  first_name = response.parsed_response['results'].first['name']['first']
  last_name = response.parsed_response['results'].first['name']['last']

  last_name + ', ' + first_name
end

def phone_query(response)
  response.parsed_response['results'].first['phone']
end

get '/user' do
  content_type :json
  redis = Redis.new(url: 'redis://:3QmZ3oBRMeIjA5TKgLPkJaFzCk5PKfHu@redis-13992.c1.us-west-2-2.ec2.cloud.redislabs.com:13992/0')
  query = user_query
  redis.set('user', query)

  redis.get('user')
end
