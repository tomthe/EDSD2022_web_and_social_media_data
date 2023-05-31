# Data transformation
#
# **Exercise 5.3.1:** Download more Data from https://datacatalog.worldbank.org/ 
# just like you did in exercise 5.2 
# and convert it to the following format and save it as a csv-file 
# (you can use the [countrycode package](https://github.com/vincentarelbundock/countrycode)
# to convert the country names to country codes, if you need to):
#
# Country, ISO3_countrycode, year, GDP, population, GDP per capita, GDP per capita (PPP)
# country
# total population
# rural population (percentage)  
# urban population (percentage)
# rural population growth (percentage)
# urban population growth (percentage)

# 1) download GDP data from the world-bank:
# open https://databank.worldbank.org/source/population-estimates-and-projections#
# select the population-estimates-and-projections database
# select all countries and regions
# select the listed series
# select all the years
# "Apply changes"
# Download as csv-file, save and decompress it to a known place

# 2) read the csv-file with the function read.csv into a dataframe:
library(dplyr)
library(ggplot2)
library(tidyverse)

fn <- "./population_urban_population_world_bank_Data.csv" #change this filename to the file you downloaded
df_population_wide <- read.csv(fn, header=TRUE, sep=",")
# look at the beginning of the dataframe:
head(df_population_wide)
# use a text editor or something else to understand how the data is structured
# The format is called "wide" format, because the data is spread over several columns.
# The format we want to have is called "tidy". This is the format proposed
# by the tidyverse project and it is easier to work with.

# by googling "R convert wide to tidy" you can find lots of tutorials on how to
# convert wide to tidy. But the best information often can be found in 
# the official documentation. But it is still quite tricky to figure out where
# you have to put which column name

df_population_wide <- df_population_wide %>%
  pivot_longer(-c("ï..Country.Name","Country.Code","Series.Name","Series.Code"),
               names_to="year",
               values_to = "value")
#view(df_population_wide)

#this is too wide. But we can do the opposite operation to make it "tidy":

df_population_tidy <- df_population_wide %>%
  pivot_wider(names_from =c("Series.Name","Series.Code"),
              values_from="value")
view(df_population_tidy)





# **Exercise 5.4:** Now use the "WDI"-package to do the same thing. 
# You can find instructions on how to install and use the WDI-package here:
# https://github.com/vincentarelbundock/WDI
# 

install.packages("WDI")
library("WDI")

# it gives us really easy access to the data:
WDIsearch('urban.*opulation.*growth')
# pick your results:
# "Urban population (% of total population)" "SP.URB.TOTL.IN.ZS" 
# "Urban population growth (annual %)" "SP.URB.GROW" 
View(WDIsearch("rural population*"))
#"Rural population growth (annual %)" 
#"Rural population (% of total population)"  

dat = WDI(indicator=c("SP.RUR.TOTL.ZG","SP.URB.TOTL.IN.ZS", "SP.RUR.TOTL.ZS") , country="all", start=1960, end=2012)
View(dat)

library(ggplot2)
g <- ggplot(dat, aes(year, SP.RUR.TOTL.ZS, color=country)) + geom_line(aes(frame=country)) + 
  xlab('Year') + ylab('GDP per capita')



WDIsearch("elevation")

install.packages("plotly")
library(plotly)

ggplotly(g)
