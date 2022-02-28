
# Transforming tables is quite important, as data is not always in the best format.
# But it is not always easy, I still have to use some of trial and error to it.
# It is important to learn: It is possible to transform it however you want, 
# you just have to google a lot...

# **Exercise 2.4.1:** Download more Data just like you did in exercise 2.2 
# and convert it to the following format and save it as a csv-file 
# (you can use the [countrycode package](https://github.com/vincentarelbundock/countrycode)
# to convert the country names to country codes, if you need to):
#
# country (name)
# ISO3 countrycode
# total population
# rural population (percentage)  
# urban population (percentage)

# 1) download GDP data from the world-bank:
# open https://databank.worldbank.org/source/population-estimates-and-projections#
# select the population-estimates-and-projections database
# select all countries and regions
# select the listed series
# select all the years
# "Apply changes"
# Download as csv-file, save and decompress it to a known place

# 2) read the csv-file with into a dataframe:
library(dplyr)
library(ggplot2)
library(tidyverse)

fn <- "D:\\dev\\data\\population_urban_population_world_bank_Data.csv"
df_population_wide <- read.csv(fn, header=TRUE, sep=",")
# look at the beginning of the dataframe:
head(df_population_wide)
# use a text editor or something else to understand how the data is structured
# The format is called "wide" format, because the data is spread over several columns.
# The format we want to have is called "tidy". This is the format proposed
# by the tidyverse project and it is easier to work with.

# by googling "R convert wide to tidy" you can find lots of tutorials on how to
# convert wide to tidy. But the best information often can be often found in 
# the official documentation. But it is still quite tricky to figure out where
# you have to put which column name

df_population_wide <- df_population_wide %>%
  pivot_longer(-c("ï..Country.Name","Country.Code","Series.Name","Series.Code"),
               names_to="year",
               values_to = "value")
view(df_population_wide)

#this is too wide. But we can do the opposite operation to make it tidy:

df_population_tidy <- df_population_wide %>%
  pivot_wider(names_from =c("Series.Name","Series.Code"),
              values_from="value")
view(df_population_tidy)





# **Exercise 2.4.2:** Now use the "WDI"-package to do the same thing. 
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
WDIsearch("rural population*")
#"Rural population growth (annual %)" 
#"Rural population (% of total population)"  

WDIsearch("gdp.*ppp*")
#"Rural population growth (annual %)" 
#"Rural population (% of total population)"  

dat = WDI(indicator=c("SP.URB.TOTL.IN.ZS", "SP.RUR.TOTL.ZS","NY.GDP.PCAP.PP.KD") , country=c('DE','CA','US','FR'), start=1960, end=2012)
view(dat)


# 2.4.3 Explore the WDIsearch with your own queries, Download data that you find interesting!
# use the years 2000 to 2020
# use the following country-code list (unless you want are interested in other countries, then feel free to use anything):
countrycodes_europe <- c(
  'AL', 'AD', 'AM', 'AT', 'BY', 'BE', 'BA', 'BG', 'CH', 'CY', 'CZ', 'DE',
  'DK', 'EE', 'ES', 'FO', 'FI', 'FR', 'GB', 'GE', 'GI', 'GR', 'HU', 'HR',
  'IE', 'IS', 'IT', 'LI', 'LT', 'LU', 'LV', 'MC', 'MK', 'MT', 'NO', 'NL', 
  'PL', 'PT', 'RO', 'RS', 'RU', 'SE', 'SI', 'SK', 'SM', 'TR', 'UA'
)
# 2.4.4 Make some Plots of these datasources

dat = WDI(indicator=c("SP.URB.TOTL.IN.ZS", "SP.RUR.TOTL.ZS","NY.GDP.PCAP.PP.KD") , country=countrycodes_europe, start=2000, end=2020)
view(dat)

library(ggplot2)
g <- ggplot(dat, aes(year, SP.RUR.TOTL.ZS, color=country)) + geom_point() + 
  xlab('Year') + ylab('Rural population %')
g

# Filter your Data on-the-fly:
g <- ggplot(dat %>% filter(year>1990), aes(year, NY.GDP.PCAP.PP.KD, color=country)) + geom_line(aes()) + 
  xlab('Year') + ylab('GDP per capita')
g



# Convert your ggplot-graphs into interactive, animated html-graphs with plotly:

install.packages("plotly")
library(plotly)

# create a plot, just like you would create a ggplot2-plot:
g <- ggplot(dat %>% filter(year>1990), aes(x=NY.GDP.PCAP.PP.KD, y= SP.URB.TOTL.IN.ZS, frame=year, color=country)) + geom_point()
g

# notice that we added frame=year this means there will be a new dimension: frame
# one graph for every year:
ggplotly(g)



#######################################

