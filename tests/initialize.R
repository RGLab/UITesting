library(methods)
library(RSelenium)
library(testthat)
library(XML)
library(digest)

ISR_login <- Sys.getenv("ISR_login")
ISR_pwd <- Sys.getenv("ISR_pwd")

pJS <- phantom()
Sys.sleep(5)

remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open(silent = TRUE)
remDr$maxWindowSize()
remDr$setImplicitWaitTimeout(milliseconds = 20000)

machine <- ifelse(Sys.getenv("TRAVIS_BRANCH") == "master", "www", "test")
siteURL <- paste0("https://", machine, ".immunespace.org")

# helper functions ----
context_of <- function(file, what, url, level = NULL) {
  level <- ifelse(is.null(level), "", paste0(" (", level, " level) "))
  msg <- paste0("\n", file, ": testing '", what, "' page", level, "\n", url, "\n")
  context(msg)
}


# tests ----
test_connection <- function(remDr, pageURL, expectedTitle) {
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
    expect_equal(pageTitle, expectedTitle)
  })
}

test_module <- function(module) {
  test_that(paste(module, "module is present"), {
    module <- remDr$findElements(using = "css selector", value = "div.ISCore")
    expect_equal(length(module), 1)
    
    tab_panel <- remDr$findElements(using = "class", value = "x-tab-panel")
    expect_equal(length(tab_panel), 1)
  })
}

test_tabs <- function(x) {
  test_that("tabs are present", {
    tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
    expect_equal(length(tab_header), 1)
    
    tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
    expect_equal(length(tabs), 4)
    
    expect_equal(tabs[[1]]$getElementText()[[1]], x[1])
    expect_equal(tabs[[2]]$getElementText()[[1]], x[2])
    expect_equal(tabs[[3]]$getElementText()[[1]], x[3])
    expect_equal(tabs[[4]]$getElementText()[[1]], x[4])
  })
}
