library(rvest)
library(dplyr)

# Prepare this lessen by loading a dataframe of scraped news headlines

dfsmall  <- read.csv("./data/df_headlines_sentiment_small.csv")
dfbig    <- read.csv("../data/df_headlines_sentiment_7months.csv")

View(dfsmall)

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
# State of the art models for sentiment analysis use very large deep neural 
# networks pretained on gigabytes or terabytes of text data. They require
# a good GPU to run fast. 
# The syuzhet-package does not use these advanced techniques, but it is still used
# in research nevertheless.
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
sentiments <- get_sentiment(dfsmall$headline,language="english",method="syuzhet")
# the result is one floating point number for every input text. Negative values indicate a negative
# sentiment, positive numbers indicate a positive sentiment

# the syuzhet-package provides different sentiment models.
# nrc assignes multiple feelings to every input text:
sentiments_nrc <- get_nrc_sentiment(dfsmall$headline)

#now we combine the sentiments with the dfheadlines2 dataframe:
df_headlines_sentiments <- cbind(dfsmall,sentiments,sentiments_nrc)

# Take a look into the data. Is the sentiment analysis realistic?
View(df_headlines_sentiments)

result_folder <- "./"
write.csv(df_headlines_sentiments,paste0(result_folder,"df_headlines_sentiments1__.csv"))


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

# I have scraped a slightly bigger dataset for a previous course.
# it contains headlines from 4 different news websites.
# You can find it in the data subfolder.
# This dataset offers more ways to filter and plot news data.

fn ="data/df_headlines_sentiments_1.csv"
# (maybe you need adjust the filename fn)
df_headlines_sentiments = read.csv(fn)

View(df_headlines_sentiments)

df_headlines_sentiments$date = as.Date(df_headlines_sentiments$date)
print(head(df_headlines_sentiments))
summary(df_headlines_sentiments)



# ggplot is a very versatile and popular data visualization library
# This is a good introduction, if you want to know more:
# https://uc-r.github.io/ggplot_intro
library(ggplot2)
ggplot(data = df_headlines_sentiments, mapping = aes(x = date, y = sentiments)) +
  geom_violin(alpha=0)+
  geom_jitter(alpha = 0.3, color = "tomato")
geom_point(alpha = 0.1, aes(color = trust))


filterwords = 'Paris|paris|France|French'
filterwords = 'Gaza'

df_filtered <- df_headlines_sentiments %>%
  filter(str_detect(headlines, filterwords))
View(df_filtered)

ggplot(data = df_filtered, mapping = aes(x = date, y = sentiments)) +
  #geom_violin(alpha=0)+
  geom_jitter(alpha = 0.3, color = "tomato")
geom_point(alpha = 0.1, aes(color = sentiment))



##########
# Assignment 1 (This will be a part of the final assignment):
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
# Scrape the temperature at your affiliation's city and print it to the console
# 
# Here it starts with reading the page for my affilliations city:

page_weather <- read_html("https://kachelmannwetter.com/de/wetter/2844588-rostock")


temperature <- page_weather %>% html_nodes(selector)%>% html_text2()
temperature

#####

page_weather <- read_html("https://www.windfinder.com/forecast/paris_ile_de_france_france")
selector = "._2PEcpOHB8qFkefFwy96UF6"
selector = ".current-weather-info"


temperature <- page_weather %>% html_nodes(selector)%>% html_text2()
temperature




###########
# Assignment 3:
# Please read
# "The Impact of Hurricane Maria on Out-migration from Puerto Rico: Evidence
# from Facebook Data" (Alexander 2019). You can find it in the readings folder