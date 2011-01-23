require 'rest-client'
require 'json'

class Couch
  server = ENV['CLOUDANT_URL'] || 'http://127.0.0.1:5984'
  database = "#{server}/interest"
  @document = RestClient::Resource.new "#{database}/data"

  def self.get
    JSON.parse @document.get
  end

  def self.put(data)
    @document.put data.to_json,
      :content_type => 'application/json'
  end
end
