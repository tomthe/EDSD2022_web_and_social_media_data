## Using simple Web APIs

####################################
# 0. Parsing JSON
####################################
# the jsonlite package can parse json-strings so that 
# it is easier to access the data inside them:
install.packages("jsonlite")

library(jsonlite)

# This is a simple example of a json-file:
json_string <- '{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": [
      {"value": "New", "onclick": "CreateNewDoc()"},
      {"value": "Open", "onclick": "OpenDoc()"},
      {"value": "Close", "onclick": "CloseDoc()"}
    ]
  }
}}'

# we can parse the string with jsonlite::fromJSON:
json_parsed <- fromJSON(json_string)

#Then we can use $ to access sub-parts of the hierarchical json object:
json_parsed$menu$value

# Try to acces the string "file":
json_parsed$menu$

# get the value of the first menuitem:
json_parsed$menu$popup$menuitem$value[1]



#####################################
# 1. Weather API - Retrieving the temperature in Rostock
#####################################

# Most APIs require an authentication by the user, but some don't. Open-meteo is a
# weather API that does not require an authentication and it is easy to get started.
# Good APIs have a good documentation. Use the documentation!

# https://open-meteo.com


# Install and load the necessary packages to do HTTP-request and read json:
install.packages("httr") # this package can request URLs over the internet

library(httr) # httr will do the requests for us (instead of rvest)
library(jsonlite)
# library(lubridate)


# Retrieve the URL and the parameters from the documentation of the API!
# Call the API and store the response in a variable

url1 = "https://archive-api.open-meteo.com/v1/era5?latitude=-41.2865&longitude=174.7762&start_date=1990-01-01&end_date=1990-01-02&hourly=temperature_2m,relativehumidity_2m"
url1 = "https://api.open-meteo.com/v1/forecast?latitude=41.39&longitude=2.16&hourly=temperature_2m,relativehumidity_2m"

res <- GET(url1)
res

# 4. Retrieve the desired information from the variable

rescontent = content(res) # content() is a function of the httr package
# click on the function and press F1 to find out more!

# look into the content to find out what exactly we want to extract
rescontent$hourly$temperature_2m

# this gives us the temperature in the first predicted hour:
rescontent$hourly$time[[1]]




##########################
# Exercise 3.2.1
# Get the temperature, cloud cover and Humidity of your hometown at noon on your last birthday!
# consult the open-meteo documentation on how to retrieve data from the past
#
# Optional Extra-Exercise 1: plot the temperature on 20 points from the north-pole
# to the south pole in a line-plot
#
# Optional Extra-Exercise 2: Use the OpenAlex API to search for a researcher of 
# your choice. Then plot some information about her/his works! 
# https://docs.openalex.org/api/get-lists-of-entities/search-entity-lists
#
# optional APIs to try:
# https://api.adviceslip.com/
# http://www.omdbapi.com/
# https://github.com/public-apis/public-apis
# http://open-notify.org/Open-Notify-API/ISS-Location-Now/
# https://developer.spotify.com/documentation/web-api/
# https://spoonacular.com/food-api
# geocoding and reverse geocoding apis
#
#############################


