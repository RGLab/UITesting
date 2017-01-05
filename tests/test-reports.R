context("reports page")

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to reports page", {
  pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?pageId=Reports")
  remDr$navigate(pageURL)
  if (remDr$getTitle()[[1]] == "Sign In") {
    id <- remDr$findElement(using = "id", value = "email")
    id$sendKeysToElement(list(ISR_login))
    
    pw <- remDr$findElement(using = "id", value = "password")
    pw$sendKeysToElement(list(ISR_pwd))
    
    loginButton <- remDr$findElement(using = "class", value = "labkey-button")
    loginButton$clickElement()
    
    Sys.sleep(1)
  }
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "Reports: /Studies/SDY269")
})

test_that("'List of Available Reports' module is present", {
  webElems <- remDr$findElements(using = "id", value = "dataviews-panel-1")
  expect_equal(length(webElems), 1)
  
  webElems <- remDr$findElements(using = "css selector", value = "a[href*='/reports/Studies/SDY269/runReport.view?reportId=']")
  if (length(webElems) == 0) {
    webElems <- remDr$findElements(using = "class", value = "x4-grid-empty")
    expect_true(webElems[[1]]$getElementText()[[1]] == "0 Matching Results")
  } else {
    expect_true(length(webElems) > 0)
  }
})