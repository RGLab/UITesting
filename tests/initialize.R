library(methods)
library(RSelenium)
library(testthat)
library(XML)
library(digest)

ISR_login <- Sys.getenv("ISR_login")
ISR_pwd <- Sys.getenv("ISR_pwd")
SAUCE_USERNAME <- Sys.getenv("SAUCE_USERNAME")
SAUCE_ACCESS_KEY <- Sys.getenv("SAUCE_ACCESS_KEY")

machine <- ifelse(Sys.getenv("TRAVIS") == "true", "TRAVIS", "LOCAL")
server <- ifelse(Sys.getenv("TRAVIS_BRANCH") == "master", "www", "test")

build <- Sys.getenv("TRAVIS_BUILD_NUMBER")
job <- Sys.getenv("TRAVIS_JOB_NUMBER")
jobURL <- paste0("https://travis-ci.org/RGLab/UITesting/jobs/", Sys.getenv("TRAVIS_JOB_ID"))
name <- ifelse(machine == "TRAVIS", 
               paste0("UI testing `", server, "` by TRAVIS #", job, " (", jobURL, ")"), 
               paste0("UI testing `", server, "` by ", Sys.info()["nodename"]))
url <- ifelse(machine == "TRAVIS", "localhost", "ondemand.saucelabs.com")

ip <- paste0(SAUCE_USERNAME, ":", SAUCE_ACCESS_KEY, "@", url)
port <- ifelse(machine == "TRAVIS", 4445, 80)
browserName <- ifelse(Sys.getenv("SAUCE_BROWSER") == "", 
                      "chrome", 
                      Sys.getenv("SAUCE_BROWSER"))
extraCapabilities <- list(name = name, 
                          build = build,
                          username = SAUCE_USERNAME, 
                          accessKey = SAUCE_ACCESS_KEY, 
                          tags = list(machine, server))

remDr <- remoteDriver$new(remoteServerAddr = ip, 
                          port = port, 
                          browserName = browserName, 
                          version = "latest", 
                          platform = "Windows 10", 
                          extraCapabilities = extraCapabilities)
remDr$open()
write(paste0("export SAUCE_JOB=", remDr@.xData$sessionid), "SAUCE")

remDr$maxWindowSize()
remDr$setImplicitWaitTimeout(milliseconds = 20000)

siteURL <- paste0("https://", server, ".immunespace.org")


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
