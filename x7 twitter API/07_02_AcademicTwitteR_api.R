# EDSD Accessing Twitter data via the Academic Twitter API

# Authors: Jisu Kim and Tom Theile

# This is an adapted version of Jisu Kims' Tutorial for PHDS, November 2022.
# This script shows how to use the package academictwitteR to access the V2 Twitter API. 

# For more details, please check out also the package descriptions here: 
# https://rdrr.io/cran/academictwitteR/f/vignettes/academictwitteR-build.Rmd


# Load or install academictwitteR package:
# install.packages("academictwitteR");
library(academictwitteR)

# Before you begin, we need to set the bearer token:

set_bearer() 

# Add line: TWITTER_BEARER=YOURTOKENHERE to .Renviron on new line, 
# replacing YOURTOKENHERE with your actual bearer token
# then restart R (Menu-->Session-->Restart R)

# check that your token is set properly. This should print your token:
get_bearer() 



### Set query
# Once the bearer token is set, we can start downloading the data!


# Let's first build the query!
# You can ever consult the Twitter-docs and build the query yourself:
# https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query
# 
# Or you can use the function build_query from the academictwitteR-package
#   Some of the arguments available on academictwitteR are the following:
#     query: Search query or queries e.g. "cat"
#     exact_phrase: 	If TRUE, only tweets will be returned matching the exact phrase
#     users: 	string or character vector, user handles to collect tweets from the specified users
#     is_reply: 	If TRUE, only reply tweets will be returned
#     is_verified: 	If TRUE, only tweets whose authors are verified by Twitter will be returned
#     has_hashtags: 	If TRUE, only tweets containing hashtags will be returned
#     has_links: 	If TRUE, only tweets containing links and media will be returned
#     has_mentions: 	If TRUE, only tweets containing mentions will be returned
#     has_geo: 	If TRUE, only tweets containing Tweet-specific geolocation data provided by the Twitter user will be returned
#     place: 	Name of place e.g. "London"
#     country: 	Name of country as ISO alpha-2 code e.g. "GB"
#     point_radius: 	A vector of two point coordinates latitude, longitude, and point radius distance (in miles)
#     bbox: 	A vector of four bounding box coordinates from west longitude to north latitude
#     lang: 	A single BCP 47 language identifier e.g. "fr"
#     url: 	string, return tweets containing specified url

# Useful tools to get bounding box coordinates include: 
#       -https://www.openstreetmap.org/#map=12/33.7673/-84.4201
#       -https://boundingbox.klokantech.com/
# 
# Rest of the details on the query can also be specified in the call.

query <- build_query(
  query="migrant",
  #country = "ES",
  #place = "Barcelona",
  #lang = "de",
  #bbox= c(-84.4380, 33.7195, -84.3468, 33.8004),
  #has_geo=T,
)
query

query = 'qatar "human rights"'



### Count number of tweets 
# Now we check how many tweets we can access using this query:

tcounts <- count_all_tweets(query = query,
      start_tweets = "2020-10-01T00:00:00Z",
      end_tweets = "2020-10-30T01:00:00Z",
      bearer_token = get_bearer(),
      n = 30,                  # stop after n tweet counts
      granularity = "day",     # Options are "day"; "hour"; "minute". Default is day
      verbose = TRUE,          # If FALSE, query progress messages are suppressed
      )
tcounts
sum(tcounts$tweet_count)


#Plot the number of tweets per day:
library(tidyverse)
library(lubridate)
tcounts %>% mutate(start = ymd_hms(start)) %>% select(start, tweet_count) %>%
  ggplot(aes(x = start, y = tweet_count)) + geom_line() +
  xlab("Date") + ylab("Number of tweets")



### Get all tweets
# We can then download all the tweets!

query <- build_query(
  query="overdose (died OR dead OR mortality)",
  country = "US",
  #place = "Texas",
  #lang = "en",
  #bbox= c(-84.4380, 33.7195, -84.3468, 33.8004),
  #has_geo=T,
)
query

path_dir = "tweetdata1" # specify a subdirectory where the data should be saved
tweets <- get_all_tweets(
                query = query,
                start_tweets = "2021-03-21T00:00:00Z",
                end_tweets = "2021-03-28T01:00:00Z",
                n = 200,
                data_path="./tweetdata1",
                bind_tweets= T,      #If TRUE, tweets captured are bound into a data.frame for assignment
                # user = T,            #if we want to bundle user-level data,
                # export_query=T       #If TRUE, queries are exported to data_path
              )

tweets <- bind_tweets(data_path = path_dir)
View(tweets)


# We have both users' profile and tweet information stored in the path_dir as json-file

### Load data
files <- list.files(path_dir, pattern = "^users")
user_content <- jsonlite::read_json(file.path(path_dir, files[1]), simplifyVector = T)
places_content <- user_content$users$location
length(places_content)
user_content$tweets$text


## We can also download other information:
### Tweets of a user

# To extract tweets based on the user ID:
users<- c("MPIDRnews")  

# stores tweets in data_path folder as a series of jsons
path_dir = "tweetdata_users" # change the folder
tweets_paa  <- get_all_tweets(users,
                          start_tweets = "2021-03-28T00:00:00Z",
                          end_tweets = "2022-03-06T11:59:59Z",
                          data_path = path_dir,                       #link to storage folder
                          bind_tweets = T,                        #convenience function to bundle the JSONs into a data.frame object
                          n=50,
                          bearer_token = get_bearer(),
                          )
View(tweets_paa)



### Timeline (home and user-timeline) of a user
userid = get_user_id("MPIDRnews")[1]
timeline_tweets <- get_user_timeline(userid,   #MPIDRnews requires user id
                        start_tweets = "2021-03-28T00:00:00Z",
                        end_tweets = "2022-03-06T11:59:59Z",
                        bearer_token = get_bearer(),
                        data_path = path_dir,                #link to storage folder
                        bind_tweets = T,                      #convenience function to bundle the JSONs into a data.frame object
                        n=50,
                        )
View(timeline_tweets)


### Get list of followers
users<- c("573691525")  

followers <- get_user_followers(users) # we can use a much higher n, but then we will get blocked by twitter if we all do it at once
length(followers$id)
View(followers)


### Get list of friends... 
friends <- get_user_following(users)
length(friends$id)
View(friends)



#################################
## Exercises 
### When did @MPIDRnews create the account?
# Check here for help: https://rdrr.io/cran/academictwitteR/man/get_user_profile.html



### Find how many tweets related to #covid19 have been sent out from @MPIDRnews between 2022-01-01 to 2022-03-31


### compare 3 languages: tweet-counts for the #migrant topic (with geo) between 2022-09-01 to 2022-11-3


### Find the top 5 languages used in the #migrant topic (with geo) between 2022-09-01 to 2022-11-3





