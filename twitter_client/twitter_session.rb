require 'launchy'
require 'oauth'
require 'json'
require 'rest-client'
require 'addressable/uri'
require 'nokogiri'

require_relative 'consumer_key'
require_relative 'consumer_secret'

class TwitterSession

  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")
  @@access_token = nil

  def self.access_token
    return @@access_token if @@access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    Launchy.open(authorize_url)
    oauth_verifier = gets.chomp

    @@access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier)
  end

end

