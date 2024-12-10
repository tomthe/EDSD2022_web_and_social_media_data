# Some more modern websites use a lot of Javascript to render their content.
# Often these websites are more interactive "applications" instead of just 
# showing some text. Examples include the Facebook feed, the Facebook advertising-
# platform, many search pages like booking.com, Airbnb or the Linkedin-recruiter
# platform. Often, these websites are especially interesting for computational
# social sciences because they often contain a lot of data that can be scraped.

# With the previous method of downloading a website with rvest, we would not get
# all that data, because we would only get some HTML-code without the actual content
# or data.

# We have to analyze the website and find out how it gets the data from the server.
#
# * Therefore we open the website in a browser and look at the network-tab in the
# developer-tools. We can see that the website sends a lot of requests to the server.
# * We have to identify the requests that are relevant for our analysis. We can
# see the response data of every request in the network-tab. We can filter to show 
# only requests for JSON-data, which is a structured data format that is easy to 
# parse with Javascript and R. The data is very unlikely to be in images or other
# formats.

# * We can then copy this request!
#    Important: right click on the request, then copy-> copy as cURL(bash) (or posix, not cmd) 
# * We can use https://curlconverter.com/r-httr2/ to convert this into R code!
# * Look into that r code! Paste it into this R script!
# * execute all the steps
#
# * now we can use the steps from 02_using_web_APIs.R to take a look into that data.




















response


library(httr2) # httr will do the requests for us (instead of rvest)
library(jsonlite)#

resp <- response

# now we can have a look at what the server of brightsky returned:
resp %>% resp_content_type()
#> [1] "application/json"  <-- this means the response is in the JSON format
resp %>% resp_status_desc()
#> [1] "OK" <-- that means the request was correct and could be resolved

resp %>% resp_body_html()
# --> error, because the API replies with JSON and not HTML
resp %>% resp_body_string()
# --> the raw json string. 

# httr2 has a function to parse the json built in:
resp %>% resp_body_json()
# this shows all the data. Let's copy this into a variable:
responsdata <- resp %>% resp_body_json()
responsdata
