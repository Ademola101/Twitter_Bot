require 'twitter'
require_relative '/application
'

module Twitter
  class Retweet
    attr_reader :config

    def initialize
      @config = twitter_api_config
    end

    def action
      rest_client = config_rest_client
      stream_client = config_stream_client
      loop do
        re_tweet(rest_client, stream_client)
      end
    end

    private

    def twitter_api_config
      {
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        access_token: ENV['ACCESS_TOKEN'],
        access_token_secret: ENV['ACCESS_TOKEN_SECRET']
      }
    end

    MAXIMUM_HASHTAG_COUNT = 10

    def config_rest_client
      puts 'Cofiguring rest client'
      Twitter::REST::Client.new(config)
    end

    def config_stream_client
      puts 'Configuring streaming client'
      Twitter::REST::Client.new(config)
    end

    def should_re_tweet?(tweet)
      tweet?(tweet) && !retweet?(tweet) && allowed_hashtag_count?(tweet) && !sensitive_tweet?(tweet) && allowed_hashtags?(tweet)
    end

    def tweet?(tweet)
      tweet.is_a?(Twitter::Tweet)
    end

    def allowed_hashtags?(tweet)
      includes_allowed_hashtags = false
    
      hashtags(tweet).each do |hashtag|
        if HASHTAGS_TO_WATCH.map(&:upcase).include?("##{hashtag[:text]&.upcase}")
          includes_allowed_hashtags = true
    
          break
        end
      end
      includes_allowed_hashtags
    end

    def hashtags(tweet)
      tweet_hash = tweet.to_h
      extended_tweet = tweet_hash[:extended_tweet]
    
      (extended_tweet && extended_tweet[:entities][:hashtags]) || tweet_hash[:entities][:hashtags]
    end

  end
end