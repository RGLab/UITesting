pageURL <- paste0(siteURL, "/GeneSetEnrichmentAnalysis/Studies/SDY269/begin.view")
context(paste0("test-gsea.R: testing 'Gene Set Enrichment Analysis' page (", pageURL, ")"))

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to the page", {
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
  expect_equal(pageTitle, "Gene Set Enrichment Analysis: /Studies/SDY269")
})