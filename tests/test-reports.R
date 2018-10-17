if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?pageId=Reports")
context_of(file = "test-reports.R",
           what = "Reports",
           url = pageURL)

test_connection(remDr = remDr,
                pageURL = pageURL,
                expectedTitle = "Reports: /Studies/SDY269")

test_that("'List of Available Reports' module is present", {
  webElems <- remDr$findElements(using = "id", value = "dataviews-panel-1")
  expect_equal(length(webElems), 1)

  webElems <- remDr$findElements(using = "css selector", value = "a[href*='/reports/Studies/SDY269/runReport.view?reportId=']")
  if (length(webElems) == 0) {
    webElems <- remDr$findElements(using = "class", value = "x4-grid-empty")
    expect_true(webElems[[1]]$getElementText()[[1]] == "0 Matching Results")
  } else {
    expect_gt(length(webElems), 0)
  }
})
