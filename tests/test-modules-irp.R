context("immune response predictor page")

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to immune response predictor page", {
  pageURL <- paste0(siteURL, "/ImmuneResponsePredictor/Studies/SDY269/begin.view")
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
  expect_equal(pageTitle, "Immune Response Predictor: /Studies/SDY269")
})