class Status
  attr_accessor :text, :user

  def initialize(hash)
    @user = hash["user"]["name"]
    @text = hash["text"]
    @hashtags = hash["entities"]["hashtags"]
    @mentions = hash["entities"]["user_mentions"]
  end

  def self.parse(json)
    Status.new(json)
  end



end