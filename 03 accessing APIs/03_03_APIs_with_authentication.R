## Using Web APIs with authentication

####################################
# 1. Register an account and get an api-key
####################################

# Most APIs require an authentication by the user.
# We will use the textsynth-API to try this out.
# Please visit:
# https://textsynth.com/
# and find out what the service can do.
# Then register an account with a valid email-address:
# https://textsynth.com/signup.html
# You can retrieve your API-token from the settings-page, when you are logged in:
# https://textsynth.com/settings.html


api_key = "b34a9c044a921493da410699d5d5a780" # copy your own API-key here

####################################
# 2. Make an authorized call to the textsynth API
####################################

library(httr) # httr will do the requests for us (instead of rvest)
library(jsonlite)

# Some APIs accept the api-token in the URL.
# This API requires the token in the Header of the HTTP-request.
# 

url <- "https://api.textsynth.com/v1/engines/gptj_6B/completions"
myprompt <- "This is the text that the AI-model is supposed to complete. You can enter whatever you like "

#add_headers( Authorization = paste0("Bearer ", api_key))

textsynth_response <- POST(url, add_headers(
      Authorization = paste0("Bearer ", api_key)),
      body = list(prompt = myprompt), encode = "json")

textsynth_response

textsynth_response$status_code

# 4. Retrieve the desired information from the variable
textsynth_json <- content(textsynth_response)
textsynth_json$text



##########################
# **Exercise/Assignment 3.3.1:**
# Retrieve the first part of a two-part joke from a joke-API,
# then send that string to the textsynth-API and print the text of
# the answer to the console.
# 
# **Exercise/Assignment 3.3.2:**
# Retrieve a joke in another language than spanish and then
# translat it to spanish. All with web-APIs.
#############################


