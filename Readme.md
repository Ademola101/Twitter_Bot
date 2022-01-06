# Twitter Retweet bot

A Twitter retweet bot that retweet my favourite hashtags

## Built with

- Ruby

## Live Demo

Check out Twitter account [@adearael](www.twitter.com/adearael)

## How to use the bot

- First off, interacting with Twitter API require an API key among others. The tokens needed can be easily aqcuired by applying for Twitter developer account at [TwitterDev](developer.twitter.com). If the application is granted, then Bingo!!!

## Seting up the repository on  PC

1. Clone this repository by using Git clone in your command prompt terminal and navigate to the repository folder path on your local machine

 ``` code
 git clone https://github.com/Ademola101/Twitter_Bot
 ```

 then

 ``` code
 cd Twitter_Bot
 ```

2. If you check the Gem file, you will recognise that we need to install the gems. Thus,
  
``` code
 bundle install
```

That will install the gems needed to run the application.

3. Navigate to the path config/application.yml and populate the tokens with your own keys from Twitter developer account.

4. Then finally, it is time to run the code. Run it by :

```  code
ruby bin/main.rb
```
