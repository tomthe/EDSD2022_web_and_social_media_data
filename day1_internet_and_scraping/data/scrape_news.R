
## Script to scrape the titles on frontpages of some news websites
# What it does:
#  define pages and their css-selectors
#  function to scrape it
#  function to save the data


# load libraries:
library(rvest)


#pages and selectors:
news_urls = c("https://www.washingtonpost.com/",
              "https://www.theguardian.com",
              "https://www.dailymail.co.uk/home/index.html",
              "https://www.foxnews.com/"
)
news_selectors = c(".left.relative , .left.relative span, .center.relative span, .left.relative span",
                   ".fc-sublink__link , .simple-content-card__headline, .js-headline-text",
                   "#content :nth-child(4) .articletext , .linkro-darkred a",
                   ".info-header .title a")
news_names = c("washingtonpost","guardian","dailymail","foxnews")

 
#' scrape_headlines
#' function to scrape a website based on the url and css-selektor
#' all headlines will be extracted and put into a dataframe.
#' The dataframe will be saved and returned.
#' The directory where it will save to is hardcoded. Change it if you use it on a different computer#'
#' @param news_url source-Url to scrape  
#' @param news_selector css-selector from selectorGadget
#' @param news_name short one-word description of the source
#'
#' @return Dataframe with all headlines, source-url and time of scrape
#' @export
#'
#' @examples
scrape_headlines = function(news_url, news_selector, news_name) {
  
  # load the page from the internet:
  news_page <- read_html(news_url)
  #news_page
  
  # save the page to a file:
  filename= paste0("U:/dev/edsd/scraping/",gsub(":", "_", as.character(Sys.time())),"_",news_name,".RDS")
  print(paste0("just scraped: ", filename, news_name))
  saveRDS(news_page, filename)
  
  headlines <- news_page %>%
    html_nodes(news_selector) %>%
    html_text()
  
  # store headlines in a dataframe together with the collection-date(now):
  headlines_df <- unique(data.frame(headlines, news_url, date=Sys.time()))
  #headlines_df
  
  return(headlines_df)
}


# prepare data-structure: a list of all dataframes
all_headlines = list()


# execute scraping and append the results to all_headlines:
for(i in 1:length(news_urls)){
  #i=2
  tempheadlines = scrape_headlines(news_urls[i], news_selectors[i], news_names[i])
  all_headlines[i] = list(tempheadlines)
}



# concatenate all dataframes to get one dataframe with all headlines of this scrape:
df_all_headlines = all_headlines[1]
for(i in 2:length(news_urls)){
  df_all_headlines <-rbind(df_all_headlines, all_headlines[i])
}

# save dataframe to file:
filename= paste0("U:/dev/edsd/scraping/",gsub(":", "_", as.character(Sys.time())),"_all_headlines_of_one_scrape.RDS")
print(paste0("finished. now save all: ", filename))
saveRDS(df_all_headlines, filename)

