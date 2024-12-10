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
library(knitr)
library(kableExtra)

## Set Facebook Keys
TOKEN        <- "TOKEN-HERE"
CREATION_ACT <- "CREATION-ACT-HERE"
VERSION      <- "VERSION-HERE"