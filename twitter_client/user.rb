require_relative 'twitter_session'

class User
  attr_reader :user

  def initialize(username)
    @user = username
  end

  def timeline
    request = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/statuses/user_timeline.json",
      :query_values => {"screen_name" => @user}
      ).to_s

    tweets = []
    raw_tweets_arr = JSON.parse(TwitterSession.access_token.get(request).body)
    raw_tweets_arr.each do |tweet|
      tweets << Status.parse(tweet)
    end

    tweets
  end

  def followers
    request = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/followers/list.json",
      :query_values => {"screen_name" => @user}
      ).to_s


    followers = []

    raw_followers_arr = JSON.parse(TwitterSession.access_token.get(request).body).first.last

    raw_followers_arr.each do |follower|
      followers << User.parse(follower)
    end

    followers
  end

  def followed_users
    request = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/friends/ids.json",
      :query_values => {"screen_name" => @user}
      ).to_s


    friend_ids = JSON.parse(TwitterSession.access_token.get(request).body)["ids"]

    User.parse_many(friend_ids)
  end

  def self.parse(json)
    User.new(json["name"])
  end

  def self.parse_many(user_id_arr)
    request = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/users/lookup.json",
      :query_values => {"user_id" => user_id_arr.join(",")}
      ).to_s

    raw_users_arr = JSON.parse(TwitterSession.access_token.get(request).body)

    users = []
    raw_users_arr.each do |user|
      users << User.parse(user)
    end
    users
  end
end