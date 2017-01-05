context("modules page")

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to modules page", {
  pageURL <- paste0(siteURL, "/project/Studies/SDY269/begin.view?pageId=Modules")
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
  expect_equal(pageTitle, "Modules: /Studies/SDY269")
})

test_that("'Active Modules' module is present", {
  webElems <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(length(webElems), 1)
  webElems <- remDr$findElements(using = "css selector", value = "a[href$='/DataExplorer/Studies/SDY269/begin.view']")
  expect_equal(length(webElems), 1)
  webElems <- remDr$findElements(using = "css selector", value = "a[href$='/GeneExpressionExplorer/Studies/SDY269/begin.view']")
  expect_equal(length(webElems), 1)
  webElems <- remDr$findElements(using = "css selector", value = "a[href$='/GeneSetEnrichmentAnalysis/Studies/SDY269/begin.view']")
  expect_equal(length(webElems), 1)
  webElems <- remDr$findElements(using = "css selector", value = "a[href$='/ImmuneResponsePredictor/Studies/SDY269/begin.view']")
  expect_equal(length(webElems), 1)
})
