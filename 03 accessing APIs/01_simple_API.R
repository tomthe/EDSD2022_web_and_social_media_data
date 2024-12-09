



# https://brightsky.dev/
# Visit the API documentation and use curlconverter to get R-code from it.





# https://curlconverter.com/r/
# paste text from curl-converter here






res$url
res$content



library(jsonlite)

# Read the content as plain text
content_text <- httr::content(res, as="text", encoding = "UTF-8")

# Parse the JSON content
content_json <- fromJSON(content_text, flatten = TRUE) 
content_json
content_json$data$attributes.body
