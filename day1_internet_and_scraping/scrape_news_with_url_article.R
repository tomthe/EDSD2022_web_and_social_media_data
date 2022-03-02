
## Script to scrape the titles on frontpages of some news websites
# What it does:
#  define pages and their css-selectors
#  function to scrape it
#  function to save the data


# load libraries:
library(rvest)


#pages and selectors:
news_urls <- c("https://www.washingtonpost.com/",
              "https://www.theguardian.com",
              "https://www.dailymail.co.uk/home/index.html",
              "https://www.foxnews.com/"
)
news_selectors <- c(".left.relative , .left.relative span, .center.relative span, .left.relative span",
                   ".fc-sublink__link , .simple-content-card__headline, .js-headline-text",
                   "#content :nth-child(4) .articletext , .linkro-darkred a",
                   ".info-header .title a")

article_selectors <- c(".ma-0.pb-md",".article-body-commercial-selector") # todo: add selectors for dailymail and foxnews!
news_names <- c("washingtonpost", "guardian", "dailymail", "foxnews")


read_article <- function(article_url, article_selector) {
  print(paste0("scraping: ", article_url))
  Sys.sleep(0.4) # sleep for 0.4 seconds, prevents being blocked
  news_page <- read_html(article_url) %>%
    html_elements(article_selector) %>%
    html_text()
  return(news_page)
}

#' scrape_headlines
#' function to scrape a website based on the url and css-selektor
#' all headlines will be extracted and put into a dataframe.
#' The dataframe will be saved and returned.
#' The directory where it will save to is hardcoded.
#' Change it if you use it on a different computer#'
#' @param news_url source-Url to scrape  
#' @param news_selector css-selector from selectorGadget
#' @param news_name short one-word description of the source
#'
#' @return Dataframe with all headlines, source-url and time of scrape
#' @export
#'
#' @examples
scrape_headlines = function(news_url, news_selector, news_name, article_selector="") {

  # uncomment the following lines to test this function line-by-line:
  # news_url = news_urls[1]
  # news_selector = news_selector[1]
  # news_name = news_names[1]
  # article_selector = article_selectors[1]
  
  
  # load the page from the internet:
  news_page <- read_html(news_url)
  #news_page
  
  # save the page to a file:
  filename= paste0("D:/dev/r/EDSD22_web_and_social_media_data/day1_internet_and_scraping/data/",gsub(":", "_", as.character(Sys.time())),"_",news_name,".RDS")
  print(paste0("just scraped: ", filename, news_name))
  saveRDS(news_page, filename)
  
  # create a dataframe and in the same step extract the headlines and links. Also save the time and date  
  dflinks <- data.frame(
    headline = news_page %>% html_nodes(news_selector) %>% html_text(),
    links = news_page %>% html_nodes(news_selector) %>% html_node("a") %>% html_attr("href"),
    scrapetime =Sys.time(),
    shortname = news_name
    #weight = characters %>% html_element(".weight") %>% html_text2()
  )

  # filter out rows without links, group double headlines.
  dflinks2 <- dflinks %>%
    filter(!is.na(links)) %>%
    group_by(headline)

  
  # uncomment this, if you want to also scrape every article!
  df_all_articles = mapply(read_article,dflinks2$links, article_selector)

  return(dflinks2)
}


# prepare data-structure: a list of all dataframes
all_headlines = list()

# execute scraping and append the results to all_headlines:
for(i in 1:length(news_urls)){

  tempheadlines = scrape_headlines(news_urls[i], news_selectors[i], news_names[i])
  all_headlines[i] = list(tempheadlines)
}

# concatenate all dataframes to get one dataframe with all headlines of this scrape:
df_all_headlines = all_headlines[1]
for(i in 2:length(news_urls)){
  df_all_headlines <-rbind(df_all_headlines, all_headlines[i])
}

# save dataframe to file:
filename= paste0("D:/dev/r/EDSD22_web_and_social_media_data/day1_internet_and_scraping/data/",gsub(":", "_", as.character(Sys.time())),"_all_headlines_of_one_scrape.RDS")
print(paste0("finished. now save all: ", filename))
saveRDS(df_all_headlines, filename)

