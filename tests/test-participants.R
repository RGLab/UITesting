if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?pageId=study.PARTICIPANTS")
context_of(file = "test-participants.R",
           what = "Participants",
           url = pageURL)

test_connection(remDr = remDr,
                pageURL = pageURL,
                expectedTitle = "Participants: /Studies/SDY269")
