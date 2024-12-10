# Please use the openAI documentation https://platform.openai.com/docs/overview 
# and https://curlconverter.com/
# to create a valid request to the openAI chatGPT API
# please use the model "GPT-4o-mini"

library(httr)

api_key <- ""

headers = c(
  `Content-Type` = "application/json",
  #Authorization = paste0("Bearer ", Sys.getenv("OPENAI_API_KEY"))
  Authorization = paste0("Bearer ", api_key)
)

data = '{\n        "model": "gpt-4o-mini",\n        "messages": [\n            {\n                "role": "system",\n                "content": "You are a helpful assistant."\n            },\n            {\n                "role": "user",\n                "content": "Write a haiku about recursion in programming."\n            }\n        ]\n    }'

res <- httr::POST(url = "https://api.openai.com/v1/chat/completions", httr::add_headers(.headers=headers), body = data)
res

contentai = content(res)
contentai$choices[[1]]$message$content
