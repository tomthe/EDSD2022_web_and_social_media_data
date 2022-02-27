# Schedule the script to run 2 times a day:

# from https://github.com/bnosac/taskscheduleR :
# "Schedule R scripts/processes with the Windows task scheduler.
# This allows R users working on Windows to automate R processes 
# on specific timepoints from R itself. Mark that if you are looking
# for a Linux/Unix scheduler, you might be interested in the R package
# cronR available at https://github.com/bnosac/cronR "


# You have to change the folder to the script!

library(taskscheduleR)

taskscheduler_create(taskname = "download_night2", rscript = "U:/dev/edsd/scraping/scrape_news_with_url_article.R", 
                     schedule = "DAILY", starttime = "00:15")


taskscheduler_create(taskname = "download_6", rscript = "U:/dev/edsd/scraping/scrape_news_with_url_article.R", 
                     schedule = "DAILY", starttime = "06:15")


taskscheduler_create(taskname = "download_12", rscript = "U:/dev/edsd/scraping/scrape_news_with_url_article.R", 
                     schedule = "DAILY", starttime = "12:15")


taskscheduler_create(taskname = "download_18", rscript = "U:/dev/edsd/scraping/scrape_news_with_url_article.R", 
                     schedule = "DAILY", starttime = "18:15")
