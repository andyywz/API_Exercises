require_relative 'user'


class EndUser < User
  def self.set_user_name(user_name)
    @@current_user = EndUser.new(user_name)
  end

  def self.me
    @@current_user
  end

  def post_status(status_text)
    request = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/statuses/update.json",
      :query_values => {"status" => status_text}
      ).to_s

    TwitterSession.access_token.post(request)
  end

  def direct_message(other_user, text)
    request = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/direct_messages/new.json",
      :query_values => {
        "screen_name" => other_user,
        "text" => text
      }
      ).to_s

    TwitterSession.access_token.post(request)
  end
end