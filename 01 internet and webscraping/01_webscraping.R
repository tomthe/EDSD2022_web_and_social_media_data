# Please read the comments and execute the code line by line (CTRL + ENTER)

#######################
# 1 - Prepare
#######################

# Install the tidyverse. The tidyverse is a compilation of useful
# packages for data science which are compatible with each other.
# You can find more information about the tidyverse here: https://www.tidyverse.org/
# This is a good and short introduction into the concepts of the tidyverse:
# https://www.r-bloggers.com/2020/06/a-very-short-introduction-to-tidyverse/

install.packages("tidyverse")

# rvest is a package that helps you to scrape websites.
# rvest is one of the packages of the tidyverse and is installed if you 
# installed tidyverse.
# It does some of the tasks that a browser does when opening a webpage.
# It can fetch the data from an URL and offers selectors to extract the
# data that you want from HTML

# load the library rvest:
library(rvest)


library(dplyr)


###################################
# 2 - Request and read a website
###################################

# Request a simple HTML page with read_html():
example_html <- read_html("http://example.com")

# look what we got:
example_html
# this should print the html of the website into the console.

# Now open example.com with a browser and start SelectorGadget.
# Select the headline "Example Domain" and copy the selector.

# Spoiler: the selector is "h1"
# now you can use the rvest function html_elements to extract all
# html elements that comply with this selector:

example_html %>% html_elements("h1")

# if we only want the text "Example Domain" we can extract it with html_text2():

example_html %>% html_elements("h1") %>% html_text2()

# you can assign the text to a variable so that you can use it later in the script:

headline <- example_html %>% html_elements("h1") %>% html_text2()
headline

# The documentation of rvest can tell you much more about what you can 
# extract with it:
# https://rvest.tidyverse.org/reference/index.html



######################################
# 3 - Scrape headlines from The Waschington Post
######################################

# open washingtonpost.com in a browser
# start SelectorGadget
# click on headlines so that selector gadgets marks the headlines yellow
# click on other elements that are now yellow to deselect them
# repeat until you have a selector string that captures most headlines and nothing else
# maybe you have to start several times from the beginning by clicking "Clear"

# fetch the html:
wp_html <- read_html("https://www.washingtonpost.com/")

# Spoiler: ".font--headline span" is a good selector string,
# but "h2" is even simpler and better:
selector <- ".font--headline span"#"h2"

# extract headlines:
headlines <- wp_html %>% html_nodes(selector)%>% html_text2()
headlines

# We can also extract all the links to the articles behind the headlines with the following code:
links <- wp_html %>%
  html_elements(selector) %>% 
  html_elements("a") %>% 
  html_attr('href')
links
# Can you guess, what the code does?



# Create a dataframe (a table) with all headlines and links (in one step):
dfheadlines <- data.frame(
  headline = wp_html %>% html_nodes(selector) %>% html_text(),
  links = wp_html %>% html_nodes(selector) %>% html_node("a") %>% html_attr("href"), #instead of extracting the text, we extract the link-tag <a href="https:\\......">text</a> and extract the href-attribute
  scrapetime =Sys.time(),
  shortname = "wp"
)
# you can view the dataframe in the RStudio GUI:
View(dfheadlines)

# Postprocessing - remove duplicates and rows without links:
dfheadlines2 <- dfheadlines %>% 
  #filter(!is.na(links)) %>% #remove rows without links
  group_by(headline) # remove duplicate headlines

View(dfheadlines2)



##########################################
# Exercise 1 - Scrape a news website!
##########################################

# 1.1 Scrape the headlines of a news website of your choice! (not WP!)
# 1.2 create a dataframe of these headlines
# 1.3 save the dataframe to a csv-file 





##########################################
# 4 Sentiment analysis
##########################################

# [Sentiment analysis](https://en.wikipedia.org/wiki/Sentiment_analysis) describes the
# extraction of "sentiment" (affection, subjective feelings) from text data, usually by
# using methods from machine learning.
# 
# Sentiment analysis itself is still an area of active research with better models
# beating the state of the art being published regularly. But for our purposes we just
# use an easy to use R-package for sentiment analysis:
#   
# https://cran.r-project.org/web/packages/syuzhet/vignettes/syuzhet-vignette.html
#
# https://cran.r-project.org/web/packages/syuzhet/syuzhet.pdf
#
# State of the art models for sentiment analysis use deep neural networks. The
# syuzhet-package does not use these advanced techniques, but is still used in
# research nevertheless.
#
# While methods like sentiment analysis are hard tasks in itself, it can be
# easily applied if other researchers provide code or even an easy to use package.
# But ease of use should not prevent you from trying to understand how this package
# comes to its results! Try to always be critical of something that might seem
# like magic to you and validate the results on your own data.


if(!require(syuzhet)){
  install.packages("syuzhet") 
  library(syuzhet)
}

# getting the sentiments is as easy as this:
sentiments <- get_sentiment(dfheadlines2$headline,language="english",method="syuzhet")
# the result is one floating point number for every input text. Negative values indicate a negative
# sentiment, positive numbers indicate a positive sentiment

# the syuzhet-package provides different sentiment models.
# nrc assignes multiple feelings to every input text:
sentiments_nrc <- get_nrc_sentiment(dfheadlines2$headline)

#now we combine the sentiments with the dfheadlines2 dataframe:
df_headlines_sentiments <- cbind(dfheadlines2,sentiments,sentiments_nrc)

# Take a look into the data. Is the sentiment analysis realistic?
View(df_headlines_sentiments)

result_folder <- "./"
write.csv(df_headlines_sentiments,paste0(result_folder,"df_headlines_sentiments1.csv"))


# Now we can filter by some criteria:
library(tidyverse)

df_war <- df_headlines_sentiments %>%
  filter(str_detect(headline, 'war')) # "word1|word2" if you want to search for all lines with word1 OR word2
View(df_war)
# Why is filtering for just "war" problematic?

# https://sebastiansauer.github.io/dplyr_filter/ explains other string-filters that you can use


df_germany <- df_headlines_sentiments %>%
  filter(str_detect(headline, 'germany'))
View(df_germany)

df_joy <- df_headlines_sentiments %>%
  filter(joy >= 2) 
View(df_joy)

# Feel free to play around with different filters


############################
# Discussion: What do you think of the sentiment results?
# Is it accurate? Would you rate the sentiment similarly?
# Where does it fail?
############################


##############
# 4.1 Plotting
##############

# I have scraped a slightly bigger dataset for a previous course this year.
# it contains headlines from 4 different news websites and from several days at
# the end of February.
# You can find it in the data subfolder on nextcloud.
# This dataset offers more ways to filter and plot news data.

fn ="df_all_headlines_sentiments_2022_02.csv"
# (maybe you need adjust the filename fn)
df_headlines_sentiments = read.csv(fn)

df_headlines_sentiments$date = as.Date(df_headlines_sentiments$date)
print(head(df_headlines_sentiments))
summary(df_headlines_sentiments)



# ggplot is a very versatile and popular data visualization library
# This is a good introduction, if you want to know more:
# https://uc-r.github.io/ggplot_intro
library(ggplot2)
ggplot(data = df_headlines_sentiments, mapping = aes(x = news_url, y = fear)) +
  geom_violin(alpha=0)+
  geom_jitter(alpha = 0.3, color = "tomato")
geom_point(alpha = 0.1, aes(color = trust))



##########
# Assignment 1:
# Create a creative/interesting plot of this dataset.
# Think about the different dimensions and contents of how you can look at this.
# Sentiment over time? Sentiment over newspaper? Count of some words over time?
# A special wordcloud? Sentiment associated to specific ...?
##########


##########
# Assignment 2:
# What temperature is it right now?
# Find the css selector to scrape the temperature from "Kachelmannwetter.com"
# (You can also choose any other weather website you want)
# Find the link to the city of your affiliated institute/university
# Scrape the temperature at your affiliation's city and print it out
# 
# Here it starts with reading the page for my affilliations city:

page_weather <- read_html("https://kachelmannwetter.com/de/wetter/2844588-rostock")

###########
# Assignment 3:
# Please read "