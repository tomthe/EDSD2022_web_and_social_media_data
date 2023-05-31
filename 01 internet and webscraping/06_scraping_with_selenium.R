# Some websites work only with enabled javascript (e.g. cnn.com)
# To scrape these, you need to run a real browser. Selenium allows
# you to automate a browser - you can remote control the browser through R.

# This script is only for information on how to get started. I had not much
# success with the combination "R + Selenium". The installation on Python is
# better supported. If you know some Python, I would recommend to try that first.

# The installation might be troublesome. You need to install 3 things:

# 1) package RSelenium 
# This package offers function to communicate from R to the "webdriver"
install.packages("RSelenium")
# read this package's vignette:
vignette("basics", package = "RSelenium")

# 2) a Browser and a "webdriver" for this Browser:
# Firefox and geckodriver: https://github.com/mozilla/geckodriver/releases/tag/v0.32.0
# or Chrome and chromedriver: https://sites.google.com/chromium.org/driver/

# 3) Selenium itself, which is a Java program (so you might also need
# to install Java first, if you haven't installed Java on your system before):
# https://github.com/SeleniumHQ/selenium/releases

# Then you need to start all these from the command line


# Once it runs, it is not much more complicated than using rvest.
# In fact, you can download the page with RSelenium and then use
# rvest to select data from it. Additionally you might have to use
# RSelenium commands to simulate user-interactions, like clicking a button
# or filling out a form.


#install.packages("tidyverse")
install.packages("RSelenium")

library(RSelenium)
library(rvest)

vignette("basics", package = "RSelenium")

rD <- rsDriver(browser="firefox", port=4545L, verbose=F)
remDr <- rD[["client"]]

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444L,
  browserName = "firefox"
)
remDr$open()
remDr$getStatus()

load <- remDr$navigate("https://cnn.com")
load
remDr$getCurrentUrl()


remDr <- rsDriver(,port = 9515L)
