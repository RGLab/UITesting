if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/begin.view?")
context_of(file = "test-datafinder.R", 
           what = "Data Finder", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Overview: /Studies")