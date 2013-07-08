require 'json'
require 'rest-client'
require 'addressable/uri'
require 'nokogiri'


class UserInput

  def get_location
    Puts "Type in your location"
    gets.chomp
  end

  def make_location
    # raw_inp = get_location
    raw_inp = "770 Broadway New York"
    params = {"address" => raw_inp, "sensor" => false}

    endpoint = Addressable::URI.new(
      :scheme => "http",
      :host => "maps.googleapis.com",
      :path => "maps/api/geocode/json",
      # :output => "json",
      :query_values => params
      ).to_s

    json = JSON.parse(RestClient.get(endpoint))
    latlng_hash = json["results"].first["geometry"].first.last
    lat, lng = latlng_hash["lat"], latlng_hash["lng"]

    Location.new(lat,lng)
  end

end

class Location
  attr_reader :lat, :lng

  def initialize(lat,lng)
    @lat = lat
    @lng = lng
  end
end


class Directions

  def give_directions(loc1, loc2)
    parse_directions( make_directions(loc1, loc2) )
  end

  def make_directions(loc1, loc2)
    origin = "#{loc1.lat},#{loc1.lng}"
    dest = "#{loc2.lat},#{loc2.lng}"

    params = {"origin" => origin, "destination" => dest, "sensor" => false}

    endpoint = Addressable::URI.new(
      :scheme => "http",
      :host => "maps.googleapis.com",
      :path => "maps/api/directions/json",
      :query_values => params
      ).to_s

    json = JSON.parse(RestClient.get(endpoint))
    html_dir = json["routes"].first["legs"].first["steps"].first["html_instructions"]
  end

  def parse_directions(html_dir)
    parsed_html = Nokogiri::HTML(html_dir)
    parsed_html.text
  end

end

class PlaceFinder

end

