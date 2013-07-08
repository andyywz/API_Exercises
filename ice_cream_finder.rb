require 'json'
require 'rest-client'
require 'addressable/uri'
require 'nokogiri'


class UserInput

  def self.get_location
    puts "Type in your location"
    gets.chomp
  end

  def self.make_location
    raw_inp = get_location
    # raw_inp = "770 Broadway New York"
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
  attr_reader :lat, :lng, :name

  def initialize(lat,lng, name = "origin")
    @lat = lat
    @lng = lng
    @name = name
  end
end


class Directions

  def self.give_directions(loc1, loc2)
    parse_directions( make_directions(loc1, loc2) )
  end

  def self.make_directions(loc1, loc2)
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
    # p json["routes"].first["legs"].first["steps"]
    steps = json["routes"].first["legs"].first["steps"]

    # html_dir = json["routes"].first["legs"].first["steps"].first["html_instructions"]

    steps.each do |step|
      str = parse_directions(step["html_instructions"])
      p str
      break if str.include?("Destination will")
    end
  end

  def self.parse_directions(html_dir)
    parsed_html = Nokogiri::HTML(html_dir)
    parsed_html.text
  end

end

class PlaceFinder

  def self.nearby_locations(loc1, radius)
    loc_str = "#{loc1.lat},#{loc1.lng}"

    params = {
      "location" => loc_str,
      "sensor" => false,
      "rankby" => "distance",
      "keyword" => "cream",
      "keyword" => "ice",
      "key" => "AIzaSyCW6W5LIs8zYdpcJaL5SnJ3QjYPu8TiD0Q"
    }

    endpoint = Addressable::URI.new(
      :scheme => "https",
      :host => "maps.googleapis.com",
      :path => "maps/api/place/nearbysearch/json",
      :query_values => params
      ).to_s

    json = JSON.parse(RestClient.get(endpoint))
    shop_list = json["results"]

    make_shop_locations(shop_list)
  end

  def self.make_shop_locations(geo_loc_array)
    output = []

    geo_loc_array.each do |location|
      name = location["name"]
      lat = location["geometry"]["location"]["lat"]
      lng = location["geometry"]["location"]["lng"]

      output << Location.new(lat, lng, name)
    end
    output
  end
end

