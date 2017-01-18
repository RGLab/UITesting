context("gene expression explorer page")

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to gene expression explorer page", {
  pageURL <- paste0(siteURL, "/GeneExpressionExplorer/Studies/SDY269/begin.view")
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
  expect_equal(pageTitle, "Gene Expression Explorer: /Studies/SDY269")
})