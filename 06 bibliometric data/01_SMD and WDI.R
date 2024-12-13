
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
View(WDIsearch('education'))

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
  xlab('Year') + ylab('Urban population (% of total population)')

g

# **Exercise 5.5**
# Download and plot the purchasing power adjusted GDP per capita for the 
# countries for which we also have Facebook data:
# Poland, Germany, France, Spain, Italy
# from 1996 to today






# Load the Country-level data of the 
# Scholarly Migration Database into a dataframe:

url_smd <- "https://raw.githubusercontent.com/MPIDR/Global-flows-and-rates-of-international-migration-of-scholars/master/data_processed/scopus_2024_V1_scholarlymigration_country_enriched.csv"
df_smd <- read.csv(url_smd)
View(df_smd)

# Plot it:
library(ggplot2)
g <- ggplot(df_smd, aes(year, number_of_inmigrations, color=iso3code)) + geom_line(aes(frame=iso3code))
  #+ ylab('Urban population (% of total population)')
g

# oh no... too many countries. We can filter the data.frame down:

countries_to_plot <- c("USA", "CHN", "GBR", "DEU", "JPN")
df_filtered <- df_smd %>% 
  filter(iso3code %in% countries_to_plot)
# plot again
g <- ggplot(df_filtered, aes(year, number_of_inmigrations, color=iso3code)) + 
  geom_line()
g




# Now let's enrich this data with more WDI data!

# feel free to use other indicators!
indicators <- c("SE.XPD.TOTL.GD.ZS")
dat = WDI(indicator=indicators , country=countries_to_plot, start=1960, end=2012)
View(dat)

# merging:
df_smd_wdi <- inner_join(df_smd, dat, by = c("iso2code" = "iso2c", "year" = "year"))
# check the size of the data.frames:
dim(df_smd)
dim(dat)
dim(df_smd_wdi)
# we lost some rows, because there is not data for every year
# and an inner_join only keeps rows with data in both data.frames


View(df_smd_wdi)

# plot again
g <- ggplot(df_smd_wdi, aes(year, SE.XPD.TOTL.GD.ZS, color=iso3code)) + 
  geom_line()
g


g <- ggplot(df_smd_wdi, aes(number_of_inmigrations, SE.XPD.TOTL.GD.ZS, color=iso3code)) + 
  geom_point() 
g






# Exercise 1

# Use data from SMD and WDI (please use different measures than in the examples)
# merge them and create a plot!



