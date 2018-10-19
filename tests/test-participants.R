if (!exists("remDr")) source("initialize.R")

page_url <- paste0(
  site_url, "/project/Studies/SDY269/begin.view?pageId=study.PARTICIPANTS"
)
context_of("test-participants.R", "Participants", page_url)

test_connection(remDr, page_url,"Participants: /Studies/SDY269")
