class Status
  attr_accessor :text, :user

  def initialize(author, message)
    @user = author
    @text = message
  end

  def self.parse(json)
    Status.new(json["user"]["name"], json["text"])
  end
end