library(academictwitteR)

# Before you begin, we need to set the bearer token:

set_bearer() 

# check that your token is set properly. This should print your token:
get_bearer() 


#########################
# **Exercise** 
# collect tweet-counts for a query and a comparison-query for 30 days.
# Repeat this for the same 30 days in in different years years.
# collect the sum of tweets for every query and every year into a list/matrix/dataframe
# Example:

query="(overdose OR addiction) (dead OR died OR mortality) place_country:US"
query2="overdose (dead OR died OR mortality) place_country:GB"
# 
query_results <- list()   
query2_results <- list()   

#now build a for-loop and go through all years since 2005:
for(iyear in 2005:2022) {
  # query twitter:
  
  # calculate sum:
  
  
  # Store output_sum in list
  query_results[[i]] <- output_sum 
  
  # then do the same with a counterfactual query:
  
}
iyear=2010

# you can copy and use this example function-call:
tcounts <- count_all_tweets(query = query,
                start_tweets = paste0(iyear,"-10-01T00:00:00Z"),
                end_tweets = paste0(iyear,"-10-30T01:00:00Z"),
                bearer_token = get_bearer(),
                n = 30,                  # stop after n tweet counts
                granularity = "day",     # Options are "day"; "hour"; "minute". Default is day
                verbose = TRUE           # If FALSE, query progress messages are suppressed
                )
tcounts
sum(tcounts$tweet_count)
