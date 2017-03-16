if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?pageId=study.PARTICIPANTS")
context_of(file = "test-participants.R", 
           what = "Participants", 
           url = pageURL)

test_that("can connect to the page", {
  remDr$navigate(pageURL)
  if (remDr$getTitle()[[1]] == "Sign In") {
    id <- remDr$findElement(using = "id", value = "email")
    id$sendKeysToElement(list(ISR_login))
    
    pw <- remDr$findElement(using = "id", value = "password")
    pw$sendKeysToElement(list(ISR_pwd))
    
    loginButton <- remDr$findElement(using = "class", value = "labkey-button")
    loginButton$clickElement()
    
    while(remDr$getTitle()[[1]] == "Sign In") Sys.sleep(1)
  }
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "Participants: /Studies/SDY269")
})
