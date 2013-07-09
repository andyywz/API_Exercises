require_relative 'hashtag'

class Status
  attr_accessor :text, :user, :hashtags, :mentions

  def initialize(hash)
    @user = hash["user"]["name"]
    @text = hash["text"]
    @hashtags = hash["entities"]["hashtags"]
    @mentions = hash["entities"]["user_mentions"]
  end

  def mentions
    ids = @mentions.map{ |hash| hash["id"] }
    User.parse_many(ids)
  end

  def hashtags
    Hashtag.parse_many(@hashtags)
  end

  def self.parse(json)
    Status.new(json)
  end
end