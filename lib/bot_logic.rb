require 'twitter'
require 'figaro'
require_relative 'application'
module Twitter
  class Retweet
    attr_reader :config

    def initialize
      @config = twitter_api_config
    end

    def perform
      rest_client = configure_rest_client
      stream_client = configure_stream_client
      loop do
        re_tweet(rest_client, stream_client)
      end
    end

    private

    MAXIMUM_HASHTAG_COUNT = 10

    def hashtags(tweet)
      tweet_hash = tweet.to_h
      extended_tweet = tweet_hash[:extended_tweet]
    
      (extended_tweet && extended_tweet[:entities][:hashtags]) || tweet_hash[:entities][:hashtags]
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

    def allowed_hashtag_count?(tweet)
      hashtags(tweet)&.count <= MAXIMUM_HASHTAG_COUNT
    end
    
    def sensitive_tweet?(tweet)
      tweet.possibly_sensitive?
    end
    
    def should_re_tweet?(tweet)
      tweet?(tweet) && !retweet?(tweet) && allowed_hashtag_count?(tweet) && !sensitive_tweet?(tweet) && allowed_hashtags?(tweet)
    end
    
    def re_tweet(rest_client, stream_client)
      stream_client.filter(:track => HASHTAGS_TO_WATCH.join(',')) do |tweet|
        puts "\nCaught the tweet -> #{tweet.text}"
    
        if should_re_tweet?(tweet)
          rest_client.retweet tweet
    
          puts "[#{Time.now}] Retweeted successfully!\n"
        end
      end
    
      puts "[#{Time.now}] Waiting for 60 seconds ....\n"
    
      sleep 60
    end
    
    def retweet?(tweet)
      tweet.retweet?
    end
    
    def twitter_api_config
      {
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        access_token: ENV['ACCESS_TOKEN'],
        access_token_secret: ENV['ACCESS_TOKEN_SECRET']
      }
    end

    def configure_rest_client
      puts 'Cofiguring rest client'
      Twitter::REST::Client.new(config)
    end
    def configure_stream_client
      puts 'configuring stream client'
      Twitter::Streaming::Client.new(config)
    end
    HASHTAGS_TO_WATCH = %w[#rails #ruby #RubyOnRails]
  end
end


