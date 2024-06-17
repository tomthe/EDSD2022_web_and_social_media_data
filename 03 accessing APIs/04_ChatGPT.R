## Using Web APIs with authentication

####################################
# 1. Register an account and get an api-key
####################################

# Most APIs require an authentication by the user.
# This is done in order to track the usage of the API 
# and to prevent abuse. 

# Instead of passing the username and password to the API,
# the user is given an API-key. This key is a long string
# of characters that is unique to the user. It tells the
# API who is making the request.

# In order to get an API-key, you have to register an account
# with the API provider on their website. Then you can
# generate an API-key in the settings of your account.

# Generate a key:
# https://platform.openai.com/api-keys


# ChatGPT API Documentation:
# https://platform.openai.com/docs/guides/text-generation/chat-completions-api


####################################
# 2. Make an authorized call to the OpenAI API
####################################
# Load required packages
library(httr) # for making HTTP requests
library(jsonlite) # for working with JSON data

# Your OpenAI API key goes here
api_key ="" # copy your own API-key here

# Set up HTTP Headers
http_headers <- add_headers(
  `Content-Type` = "application/json",
  Authorization = paste("Bearer", api_key)
)

# Request Body
request_body <- list(
  model = "gpt-3.5-turbo",
  messages = list(
    list(role = "system", content = "You are a helpful assistant."),
    list(role = "user", content = "What is the fanciest demographic research institute in France?")
  )
)

# Convert Request Body to JSON
request_body_json <- jsonlite::toJSON(request_body, auto_unbox = T)

# Send POST Request
response <- POST(
  url = "https://api.openai.com/v1/chat/completions",
  body = request_body_json,
  http_headers
)

# Print Response
print(content(response))


# Extract the content from the response
response_content <- content(response, "text", encoding = "UTF-8")

# Convert the content into JSON
response_json <- jsonlite::fromJSON(response_content, simplifyVector = FALSE)

# Print the whole JSON response
response_json

# Extract the desired value
completion <- response_json$choices[[1]]$message$content

# Print the result
print(completion)




##########################
# (Extra) Exercise/Assignment
#
# **Exercise/Assignment 3.4.1:**
# Retrieve the first part of a two-part joke from a joke-API,
# then send that string to the ChatGPT-API and print the text of
# the answer to the console.
# 
# **Exercise/Assignment 3.4.2:**
# Retrieve a joke in another language than spanish and then
# translate it to spanish (or a language of your choice).
# All with web-APIs.
#############################



#########################################################
# Annotating the headline-data with the ChatGPT API
#########################################################

# Load the data
fn = "..\\01 internet and webscraping\\data\\df_headlines_sentiments_1.csv"
df_headlines = read.csv(fn, stringsAsFactors = F)

# filter by date: only the headlines from 
# Wednesday Dec 6 2023 and Wednesday June 5 2024
# date is in the form of "YYYY-MM-DD HH:MM:SS"
df_headlines1 = df_headlines[(df_headlines$date >= "2023-12-06 00:00:00" & df_headlines$date <= "2023-12-06 03:59:59") | 
                             (df_headlines$date >= "2024-06-05 00:00:00" & df_headlines$date <= "2024-06-05 03:59:59"),]

# Let's take a look at the data
View(df_headlines1)

# how many headlines do we have?
nrow(df_headlines1)

# How much will it cost to process these?
# https://openai.com/api/pricing/
# 0.50$ for 1 Million input token
# 1 Headline = 15 words = 25 tokens
# + prompt + output = ??? 200 tokens
# 1700 * 200 ~= 400 000 token .... probably below 50 cents

# GPT-4o costs much more ( 5$ for 1 M input token), but is also better.
# Experiment with the prompt to find out which model works good enough.

# Let's create a prompt for the ChatGPT API that uses 5 headlines

# Let's create a prompt for the ChatGPT API that uses 5 headlines
library(glue)
i = 0

prompt = sprintf("Please provide a structured summary of the following headlines.
I want to know 
1. What is the main topic of the headline? Politics, Economy, Sports, Entertainment, Science, Technology, Health, Other?
2. What is the sentiment of the headline? Answer in one number between -1 and 1. -1 is very negative, 0 is neutral, 1 is very positive.
3. Is the headline about an event that included the death of at least 1 person? -1 if unkonwn, 0 if no, 1 or more if 1 or more people died.
4. Name of the main person or organization in the headline. If unknown, write 'unknown'.
5. Location of the event in the headline. If unknown, write 'unknown'.


example answer:
'Car accident in New York City, father and daughter died.', regional, -0.6, unkown, New York City

Headlines:
1. %s
2. %s
3. %s
4. %s
5. %s
6. %s
7. %s

",{df_headlines1$headline[i+1]},{df_headlines1$headline[i+2]},{df_headlines1$headline[i+3]},
                 {df_headlines1$headline[i+4]},{df_headlines1$headline[i+5]},
                 {df_headlines1$headline[i+6]},{df_headlines1$headline[i+7]})

prompt

# create a function that sends a prompt to the ChatGPT API and returns the response
send_prompt_to_chatgpt = function(prompt){
  # Request Body
  request_body <- list(
    model = "gpt-3.5-turbo",
    messages = list(
      list(role = "system", content = "You are a helpful assistant."),
      list(role = "user", content = prompt)
    )
  )
  
  # Convert Request Body to JSON
  request_body_json <- jsonlite::toJSON(request_body, auto_unbox = T)
  
  # Send POST Request
  response <- POST(
    url = "https://api.openai.com/v1/chat/completions",
    body = request_body_json,
    http_headers
  )
  
  # Extract the content from the response
  response_content <- content(response, "text", encoding = "UTF-8")
  
  # Convert the content into JSON
  response_json <- jsonlite::fromJSON(response_content, simplifyVector = FALSE)
  
  # Extract the desired value
  completion <- response_json$choices[[1]]$message$content
  
  return(completion)
}
##################

# Let's send the prompt to the ChatGPT API
response = send_prompt_to_chatgpt(prompt)
response



####################################
# do it in a loop for all headlines
####################################
# loop in chunks of 7
n = nrow(df_headlines1)
chunk_size = 7
responses = c()
headlines_sent = c() 
for(i in seq(1, n, by = chunk_size)){
  
prompt = sprintf("Please provide a structured summary of the following headlines.
I want to know 
1. What is the main topic of the headline? Politics, Economy, Sports, Entertainment, Science, Technology, Health, Other?
2. What is the sentiment of the headline? Answer in one number between -1 and 1. -1 is very negative, 0 is neutral, 1 is very positive.
3. Is the headline about an event that included the death of at least 1 person? -1 if unkonwn, 0 if no, 1 or more if 1 or more people died.
4. Name of the main person or organization in the headline. If unknown, write 'unknown'.
5. Location of the event in the headline. If unknown, write 'unknown'.


example answer:
'Car accident in New York City, father and daughter died.', regional, -0.6, unkown, New York City

Headlines:
1. %s
2. %s
3. %s
4. %s
5. %s
6. %s
7. %s

Use only one row per headline! Do not add anything else.

",{df_headlines1$headline[i+1]},{df_headlines1$headline[i+2]},{df_headlines1$headline[i+3]},
                 {df_headlines1$headline[i+4]},{df_headlines1$headline[i+5]},
                 {df_headlines1$headline[i+6]},{df_headlines1$headline[i+7]})

  response = send_prompt_to_chatgpt(prompt)
  responses = c(responses, response)
  headlines_sent = c(headlines_sent, df_headlines1$headline[i:(i+6)])
  print(response)
}

# Let's take a look at the responses
responses

# [1] "1. Tracking the Trump investigations and where they stand, politics, 0, unknown, Trump\n2. Israel has vowed to destroy Hamas. Yet the group remains largely intact., politics, -0.8, unknown, Israel, Hamas\n3. A beloved orca was about to be freed when her life ended. Then a reckoning began., other, -0.5, 1 or more, Orca, unknown\n4. Six tips to turn light chats into deep talks at holiday gatherings, other, 0.7, unknown, unknown\n5. New York special election to replace Santos scheduled for Feb. 13, politics, 0, unknown, Santos, New York City\n6. George Santos appears to be running for America’s Sassy Gay Friend, entertainment, 0.4, unknown, George Santos, America\n7. After year of division, new Pr. George’s Council leaders call for ‘unity’, politics, 0.3, unknown, Pr. George’s Council, unknown"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
# [2] "1. Jonathan Majors accuser Grace Jabbari details alleged assault at trial, entertainment, 0.4, 0, Grace Jabbari, unknown\n2. Religious Md. parents appeal to court to skip books with LGBTQ+ characters, other, -0.3, 0, unknown, Maryland\n3. For $350, George Santos will congratulate, cheer or troll you, other, 0.7, 0, George Santos, unknown\n4. Supreme Court seems inclined to narrowly uphold Trump tax provision, politics, 0.5, 0, Trump, unknown\n5. Ruling striking down Maryland handgun law on hold while governor appeals, other, 0, 0, unknown, Maryland\n6. No, Liz Cheney. You should not run for president, politics, -0.6, 0, Liz Cheney, unknown\n7. Mad at Biden’s inflation record? Another Trump term would be way worse, politics, -0.8, 0, Biden, unknown"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
# [3] "1. This ...

# split the responses into a list and create a dataframe with the headlines and the responses and columns for the structured summary
nlength = length(responses)
nlength
headlines_new = c()
responses_new = c()

for (i in 1:nlength){
  
  new_responses = strsplit(responses[i], "\n")
  
  print(paste0("----...........",i,"; ",length(new_responses[[1]])))
  for (j in 1:(length(new_responses[[1]])-1)){
    
    print(paste0("a9b",i,"; ",j, ", "))
    print(paste0("a9a",i,"; ",j, ", ", new_responses[[1]][[j]]))
    #headlines_new = c(headlines_new, headlines_sent[i])
    responses_new = c(responses_new, new_responses[[1]][[j]])
    
  }
}
headlines_new
responses_new
