if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?")
context_of(file = "test-overview.R", 
           what = "Overview", 
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
  expect_equal(pageTitle, "Overview: /Studies/SDY269")
})

test_that("'Study Overview' module is present", {
  webElems <- remDr$findElements(using = "css selector", value = "[id^=ImmuneSpaceStudyOverviewModuleHtmlView]")
  expect_equal(length(webElems), 1)
  expect_true(webElems[[1]]$getElementText()[[1]] != "")
})

test_that("'Publications and Citations' module is present", {
  webElems <- remDr$findElements(using = "id", value = "reportdiv")
  expect_equal(length(webElems), 1)
  expect_true(webElems[[1]]$getElementText()[[1]] != "")
})