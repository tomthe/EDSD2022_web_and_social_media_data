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


library(httr2)

response <- request("https://www.airbnb.com/api/v3/StaysSearch/07ea05282efd293365f6e6a08b529e39c86cfd3d7c1a1d2a4990b5d2a83b94be") |>
  req_method("POST") |>
  req_url_query(
    operationName = "StaysSearch",
    locale = "en",
    currency = "EUR"
  ) |>
  req_headers(
    accept = "*/*",
    `accept-language` = "en,de;q=0.9,de-DE;q=0.8,en-GB;q=0.7,en-US;q=0.6",
    cookie = "bev=1730804106_EANzJlYmUzZjE0ZW; everest_cookie=1730804106.EAY2JlYWI2MGEzNTAzMT.5pe1EQR_075nVJwVRFMHCDpQc9cf4uh5nCrdWRCBnr8; country=DE; cdn_exp_ef5ba54981b9fa879=control; cdn_exp_ddcdc410f52c4b893=treatment; cdn_exp_e473e2b3ee07e37b4=control; frmfctr=wide; _ccv=cban%3A0_183215%3D1%2C0_200000%3D1%2C0_183345%3D1%2C0_183243%3D1%2C0_183216%3D1%2C0_179751%3D1%2C0_200003%3D1%2C0_200005%3D1%2C0_179754%3D1%2C0_179750%3D1%2C0_179737%3D1%2C0_179744%3D1%2C0_179739%3D1%2C0_179743%3D1%2C0_179749%3D1%2C0_200012%3D1%2C0_200011%3D1%2C0_183217%3D1%2C0_183219%3D1%2C0_183096%3D1%2C0_179747%3D1%2C0_179740%3D1%2C0_179752%3D1%2C0_183241%3D1%2C0_200007%3D1%2C0_183346%3D1%2C0_183095%3D1%2C0_210000%3D1%2C0_210001%3D1%2C0_210002%3D1%2C0_210003%3D1%2C0_210004%3D1%2C0_210010%3D1; tzo=60; _user_attributes=%7B%22device_profiling_session_id%22%3A%221730804106--89e8c19ae4ab593ff01df72c%22%2C%22giftcard_profiling_session_id%22%3A%221730813786--43055a6d15abbda06d4ced1c%22%2C%22reservation_profiling_session_id%22%3A%221730813786--a75f2eb8dacb213b76252347%22%2C%22curr%22%3A%22EUR%22%7D; ak_bmsc=0BD93DD0559CCC654093D0AB36A20021~000000000000000000000000000000~YAAQn2ReaEBrT8eSAQAAWnyK/BlDmZ77EuoAdsNxJem+HGLbX5jbWjaGad8yLY3FHJBLxOYEE1zF1TILQKSpBdUWTPnTJbZB6tWk3SZboaDNT4S/M7G4VR3YlvCUzPQNcQrATs6dUIjxl3kraM/zGsAONgzMQ6tVQoWHmTqW73ensqV+5q0KWpIrXUGcFkvI2HO2JI30BFXkV1sJ/uJpZuZp3UxkSTvMOfh9KLIh+Hz7YX8t8Xp9NnuiHbbBn7hHXEWXQdFrHM/lsE8lI4yJoxK458pIDBKF+wmfNMLLMDtfl+3i3UaBSWzXIyza1gW3fA9zWVQ3sYysMUJ0z69+OKTF3bcAeBU+yJY63bYDvFfkXndHRFmuEPuWkBs+YktE9AnE/Ij8Wz6QYQ==; previousTab=%7B%22id%22%3A%22fb7f5a22-2ce9-443e-a8b1-b7cdcd837330%22%7D; jitney_client_session_id=652f161c-6f43-4e06-af75-bf69ac2242f9; jitney_client_session_created_at=1730813789.902; jitney_client_session_updated_at=1730813789.902; jitney_client_session_id=a5f4425f-0631-4950-9b03-91e4fb24131f; jitney_client_session_created_at=1730813792; jitney_client_session_updated_at=1730813792; OptanonConsent=0_179750%3A1%2C0_183095%3A1%2C0_183241%3A1%2C0_179754%3A1%2C0_183346%3A1%2C0_200000%3A1%2C0_210000%3A1%2C0_210010%3A1%2C0_183215%3A1%2C0_210004%3A1%2C0_179737%3A1%2C0_179752%3A1%2C0_179751%3A1%2C0_179749%3A1%2C0_200007%3A1%2C0_210001%3A1%2C0_200005%3A1%2C0_179740%3A1%2C0_179743%3A1%2C0_179744%3A1%2C0_183243%3A1%2C0_183096%3A1%2C0_179747%3A1%2C0_183216%3A1%2C0_200012%3A1%2C0_183219%3A1%2C0_200003%3A1%2C0_179739%3A1%2C0_210002%3A1%2C0_183217%3A1%2C0_183345%3A1%2C0_210003%3A1%2C0_200011%3A1; _cci=cban%3Aac-2511696a-aae3-40f4-97a2-1c000d0a1dcb; cfrmfctr=MOBILE; cbkp=2; bm_sv=5ACC12641B583532C92F0D83A1A60B1C~YAAQpWReaDDe6/aSAQAAXLST/BngLdXcd8Z2vYggQVOK1o9lIuawj0jznHpkYLqBwoF7AU/e/wjUQzQ9csvvWsxu9AlphGKyUqdvWFABuMruD5TpdPUtp+PMf8XVd1tJztYgsqKUAq0letwn11pbrwYPSrmynqytelJLYgcnZrl5Cow7eOkTKOrdf2zE2A8xtUHqLYX1xNnpTTPDsc3EvSb9/egiBLP18wa+wnT7fdIuVA4VTXmDQpXmHWHO4ECU4g==~1",
    `device-memory` = "8",
    dnt = "1",
    dpr = "1",
    ect = "4g",
    origin = "https://www.airbnb.com",
    priority = "u=1, i",
    referer = "https://www.airbnb.com/s/Berlin--Germany/homes?tab_id=home_tab&refinement_paths%5B%5D=%2Fhomes&flexible_trip_lengths%5B%5D=one_week&monthly_start_date=2024-12-01&monthly_length=3&monthly_end_date=2025-03-01&price_filter_input_type=0&channel=EXPLORE&query=Berlin&place_id=ChIJNzjcO6xQrEcRw55Zj-bj9tI&location_bb=Qlj6bkFEuslCWDPCQT%2F5Dg%3D%3D&date_picker_type=calendar&checkin=2024-11-26&checkout=2024-11-28&adults=1&source=structured_search_input_header&search_type=autocomplete_click",
    `sec-ch-ua` = '"Chromium";v="130", "Microsoft Edge";v="130", "Not?A_Brand";v="99"',
    `sec-ch-ua-mobile` = "?0",
    `sec-ch-ua-platform` = '"Windows"',
    `sec-ch-ua-platform-version` = '"10.0.0"',
    `sec-fetch-dest` = "empty",
    `sec-fetch-mode` = "cors",
    `sec-fetch-site` = "same-origin",
    `user-agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0",
    `viewport-width` = "1020",
    `x-airbnb-api-key` = "d306zoyjsyarp7ifhu67rjxn52tv0t20",
    `x-airbnb-graphql-platform` = "web",
    `x-airbnb-graphql-platform-client` = "minimalist-niobe",
    `x-airbnb-supports-airlock-v2` = "true",
    `x-client-request-id` = "1cvirpk1k0rgfg0lj5j5l005yr7x",
    `x-client-version` = "db33538908b8c03fc63ffca4ba29efec955d8f19",
    `x-csrf-token` = "",
    `x-csrf-without-token` = "1",
    `x-niobe-short-circuited` = "true"
  ) |>
  req_body_raw(
    '{"operationName":"StaysSearch","variables":{"staysSearchRequest":{"maxMapItems":9999,"requestedPageType":"STAYS_SEARCH","metadataOnly":false,"treatmentFlags":["feed_map_decouple_m11_treatment","stays_search_rehydration_treatment_desktop","stays_search_rehydration_treatment_moweb","m1_2024_monthly_stays_dial_treatment_flag","recommended_amenities_2024_treatment_b","filter_redesign_2024_treatment","filter_reordering_2024_roomtype_treatment","recommended_filters_2024_treatment_b"],"source":"structured_search_input_header","searchType":"autocomplete_click","rawParams":[{"filterName":"adults","filterValues":["1"]},{"filterName":"cdnCacheSafe","filterValues":["false"]},{"filterName":"channel","filterValues":["EXPLORE"]},{"filterName":"checkin","filterValues":["2024-11-26"]},{"filterName":"checkout","filterValues":["2024-11-28"]},{"filterName":"datePickerType","filterValues":["calendar"]},{"filterName":"flexibleTripLengths","filterValues":["one_week"]},{"filterName":"itemsPerGrid","filterValues":["18"]},{"filterName":"monthlyEndDate","filterValues":["2025-03-01"]},{"filterName":"monthlyLength","filterValues":["3"]},{"filterName":"monthlyStartDate","filterValues":["2024-12-01"]},{"filterName":"placeId","filterValues":["ChIJNzjcO6xQrEcRw55Zj-bj9tI"]},{"filterName":"priceFilterInputType","filterValues":["0"]},{"filterName":"query","filterValues":["Berlin"]},{"filterName":"refinementPaths","filterValues":["/homes"]},{"filterName":"screenSize","filterValues":["small"]},{"filterName":"tabId","filterValues":["home_tab"]},{"filterName":"version","filterValues":["1.8.3"]}]},"staysMapSearchRequestV2":{"requestedPageType":"STAYS_SEARCH","metadataOnly":false,"treatmentFlags":["feed_map_decouple_m11_treatment","stays_search_rehydration_treatment_desktop","stays_search_rehydration_treatment_moweb","m1_2024_monthly_stays_dial_treatment_flag","recommended_amenities_2024_treatment_b","filter_redesign_2024_treatment","filter_reordering_2024_roomtype_treatment","recommended_filters_2024_treatment_b"],"source":"structured_search_input_header","searchType":"autocomplete_click","rawParams":[{"filterName":"adults","filterValues":["1"]},{"filterName":"cdnCacheSafe","filterValues":["false"]},{"filterName":"channel","filterValues":["EXPLORE"]},{"filterName":"checkin","filterValues":["2024-11-26"]},{"filterName":"checkout","filterValues":["2024-11-28"]},{"filterName":"datePickerType","filterValues":["calendar"]},{"filterName":"flexibleTripLengths","filterValues":["one_week"]},{"filterName":"monthlyEndDate","filterValues":["2025-03-01"]},{"filterName":"monthlyLength","filterValues":["3"]},{"filterName":"monthlyStartDate","filterValues":["2024-12-01"]},{"filterName":"placeId","filterValues":["ChIJNzjcO6xQrEcRw55Zj-bj9tI"]},{"filterName":"priceFilterInputType","filterValues":["0"]},{"filterName":"query","filterValues":["Berlin"]},{"filterName":"refinementPaths","filterValues":["/homes"]},{"filterName":"screenSize","filterValues":["small"]},{"filterName":"tabId","filterValues":["home_tab"]},{"filterName":"version","filterValues":["1.8.3"]}]},"isLeanTreatment":false},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"07ea05282efd293365f6e6a08b529e39c86cfd3d7c1a1d2a4990b5d2a83b94be"}}}',
    type = "application/json"
  ) |>
  req_perform()

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
weather_data <- resp %>% resp_body_json()
weather_data
