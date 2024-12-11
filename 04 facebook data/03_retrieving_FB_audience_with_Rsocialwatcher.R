# This class is based on the documentation of the
# rsocialwatcher package by Robert May.
# Please visit https://worldbank.github.io/rsocialwatcher/ 
# for more information.


# Facebook usage by Gender and GDP

# How does Facebook usage relate to socio-economic indicators? 
# This vignette illustates the extent that Facebook usage relates to internet
# connectivity and per capita GDP in sub-Saharan Africa—as well as how Facebook 
# data can be used to examine the gender digital divide.



## Load packages
library(rsocialwatcher)
library(dplyr)
library(tidyr)
library(ggplot2)
library(WDI)
library(janitor)
library(ggpubr)




## Set Facebook Keys
TOKEN        <- ""
CREATION_ACT <- "473102145301863"
VERSION      <- "v20.0"





# Query data from WDI
#########################

# We query data from the World Development Indicators (WDI). For each country, we query:
  
#  Total population (SP.POP.TOTL)
#  Male population (SP.POP.TOTL.MA.ZS)
#  Female population (SP.POP.TOTL.FE.ZS)
#  GDP per capita (NY.GDP.PCAP.CD)
#  Individuals using the Internet, % of population (IT.NET.USER.ZS)

wdi_df <- WDI(country = c('AR','FR','IN',),  # 'ES','DE','PL','MX','PH','NG','ZA','BR','AR','TR','EG'
              indicator = c("SP.POP.TOTL",
                            "SP.POP.TOTL.MA.ZS",
                            "SP.POP.TOTL.FE.ZS",
                            "NY.GDP.PCAP.CD",
                            "IT.NET.USER.ZS"),
              start = 2021,
              end = 2021,
              extra = T)

wdi_df

# Query data from Facebook
###########################

# We separately query the number of male and female monthly active users on Facebook for each country.

fb_df <- query_fb_marketing_api(
  location_unit_type = "countries",
  location_keys      = map_param_vec(wdi_df$iso2c),
  gender             = map_param(1, 2),
  version            = VERSION, 
  creation_act       = CREATION_ACT, 
  token              = TOKEN)

View(fb_df)
# write.csv(fb_df,file="fb_audiences_1.csv")

## read the dataframe, in case FB didn't work for you:
# fb_df = read.csv(file.choose()) # fb_audiences_1.csv


# Look into the documentation of the package and directly at facebook
# https://worldbank.github.io/rsocialwatcher/reference/query_fb_marketing_api.html
# https://developers.facebook.com/docs/marketing-api/audiences/reference/basic-targeting
# https://developers.facebook.com/docs/marketing-api/audiences/reference/advanced-targeting
# to find more possible disaggregation criterias


##########################



# Cleanup data
##########################
# Here we merge together the WDI and Facebook datasets queried above and clean-up the dataset.

fb_clean_df <- fb_df %>%
  rename(iso2c = location_keys) %>%
  mutate(gender = case_when(
    gender == "1" ~ "fb_male",
    gender == "2" ~ "fb_female"
  )) %>%
  pivot_wider(id_cols = c(iso2c),
              names_from = gender,
              values_from = estimate_mau_upper_bound) %>%
  left_join(wdi_df, by = "iso2c") %>%
  clean_names() %>%
  mutate(fb_total = fb_female + fb_male,
         fb_per_female = fb_female/fb_total*100,
         wdi_per_female = sp_pop_totl_fe_zs,
         per_fb_pop = fb_total/sp_pop_totl*100) 

View(fb_clean_df)
write.csv(fb_clean_df,file="fb_audiences_2_clean.csv")


# read the dataframe, in case FB didn't work for you:
fb_clean_df = read.csv(file.choose()) # fb_audiences_1.csv

##########################

p_theme <- theme(plot.title = element_text(face = "bold", size = 10),
                 plot.subtitle = element_text(face = "italic", size = 10),
                 axis.text = element_text(color = "black"),
                 axis.title = element_text(size = 10))


p_1b <- fb_clean_df %>%
  ggplot(aes(x = per_fb_pop,
             y = it_net_user_zs,
             label=iso2c)) +
  geom_point(fill = "#4267B2",
             pch = 21) +
  geom_text(hjust=0, vjust=0) +
  labs(x = "% population on Facebook",
       y = "% population using internet",
       title = "B. Internet connectivity vs\n% population on Facebook") +
  xlim(0, 100) +
  ylim(0, 100) +
  theme_classic2() +
  p_theme 

p_1c <- fb_clean_df %>%
  ggplot(aes(x = per_fb_pop,
             y = ny_gdp_pcap_cd,
            label=iso2c)) +
  geom_point(
             fill = "#4267B2",
             pch = 21) +
  geom_text(hjust=0, vjust=0) +
  labs(x = "% population on Facebook",
       y = "GDP per capita",
       title = "C. Per capita GDP vs\n% population on Facebook") +
  theme_classic2() +
  p_theme

ggarrange(p_1b, p_1c, nrow = 1)








#########################
#  Digital Gender Divide
#########################

# Here we examine variation in the percent of Facebook users 
# that are female across countries. Panel A shows notable 
# variation in the percent of female Facebook users across 
# countries, ranging from 20 to over 50%—while, as expected, 
# the percent of female population as measured by WDI is 
# about 50% for all countries.

p_2a <- fb_clean_df %>%
  ggplot(aes(x = fb_per_female,
             y = wdi_per_female,
             label=iso2c
             )) +
  geom_point(
             pch = 21,
             size = 2,
             fill = "red") +
  geom_text(hjust=0, vjust=0) +
  xlim(20, 55) +
  ylim(20, 55) + 
  theme_classic2() +
  p_theme +
  labs(x = "% of Facebook users that are female",
       y = "% females in population (WDI)",
       title = "A. % females in population (WDI) vs\n% of Facebook users that are female")

p_2b <- fb_clean_df %>%
  mutate(income = income %>%
           factor(levels = c("Low income",
                             "Lower middle income",
                             "Upper middle income",
                             "High income"))) %>%
  ggplot(aes(x = fb_per_female,
             y = income
             ,label=iso2c)) +
  geom_boxplot(color = "gray50",
               outlier.size = 0) +
  geom_jitter(width = 0,
              height = 0.1,
              pch = 21,
              size = 2,
              fill = "red") +
  geom_text(hjust=0, vjust=0) +
  labs(x = "% of Facebook users that are female",
       y = NULL,
       title = "B. Income vs. % of Facebook users\nthat are female") + 
  theme_classic2() + 
  scale_x_continuous(breaks = seq(0, 60, 20),
                     limits = c(0, 60)) +
  p_theme

ggarrange(p_2a, p_2b, nrow = 1, widths = c(0.45, 0.55))




####################
# Exercise day 3

# Cancelled due to request from Giuliana




