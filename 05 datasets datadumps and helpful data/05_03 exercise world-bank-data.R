
# **Exercise 5.4:** Use the "WDI"-package to download data from the world-bank. 
# You can find instructions on how to install and use the WDI-package here:
# https://github.com/vincentarelbundock/WDI
# 
library(dplyr)
library(ggplot2)
library(tidyverse)


install.packages("WDI")
library("WDI")

# it gives us really easy access not only world development index data, but
# a lot of data curated by the world bank. You can search and see their
# indicators on this page: https://data.worldbank.org/indicator

# Or search it from within R:
WDIsearch('urban.*opulation.*growth')

# pick your results:
# "Urban population (% of total population)" "SP.URB.TOTL.IN.ZS" 
# "Urban population growth (annual %)" "SP.URB.GROW" 

View(WDIsearch("rural population*"))
#"Rural population growth (annual %)" 
#"Rural population (% of total population)"  

dat = WDI(indicator=c("SP.RUR.TOTL.ZG","SP.URB.TOTL.IN.ZS", "SP.RUR.TOTL.ZS") , country=c("DE","FRA","ITA"), start=1960, end=2012)
View(dat)


# Plot it:
library(ggplot2)
g <- ggplot(dat, aes(year, SP.URB.TOTL.IN.ZS, color=country)) + geom_line(aes(frame=country)) + 
  xlab('Year') + ylab('Rural population (% of total population)')

g

# **Exercise 5.5**
# Download and plot the purchasing power adjusted GDP per capita for the 
# countries for which we also have Facebook data:
# Poland, Germany, France, Spain, Italy
# from 1996 to today

# **Exercise 5.6**
# Download and plot recent population size for the countries for which we also have
# Facebook data:
# Poland, Germany, France, Spain, Italy

# **Exercise 5.7**
# Then use the Facebook data which was provided in
# D:\nextcloud\2024-EDSD-Course-Materials-Web-and-social-media-data\04 facebook data
# and plot the general population sizes
# vs the number of Facebook users for these countries.
# If you have problems with this exercise, try to get help from other students or
# from me (Tom)
