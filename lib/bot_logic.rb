require 'twitter'

module Twitter
  class Retweet
    attr_reader :config

    def initialize
      @config = twitter_api_config
    end

    def action
      rest_client = config_rest_client
      stream_client = config_stream_client
      while true
        re_tweet(rest_client, stream_client)
      end
    end
    private
    def twitter_api_config
      
    def tweeter_api_config
      {
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        access_token: ENV['ACCESS_TOKEN'],
        access_token_secret: ENV['ACCESS_TOKEN_SECRET']
      }
    end
    end
  end
end