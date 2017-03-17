if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?")
context_of(file = "test-overview.R", 
           what = "Overview", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Overview: /Studies/SDY269")

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