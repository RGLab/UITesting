pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?pageId=study.DATA_ANALYSIS")
context(paste0("test-data.R: testing 'Clinical and Assay Data' page (", pageURL, ")"))

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to the page", {
  remDr$navigate(pageURL)
  remDr$setTimeout()
  if (remDr$getTitle()[[1]] == "Sign In") {
    id <- remDr$findElement(using = "id", value = "email")
    id$sendKeysToElement(list(ISR_login))
    
    pw <- remDr$findElement(using = "id", value = "password")
    pw$sendKeysToElement(list(ISR_pwd))
    
    loginButton <- remDr$findElement(using = "class", value = "labkey-button")
    loginButton$clickElement()
    
    Sys.sleep(2)
  }
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "Clinical and Assay Data: /Studies/SDY269")
})
