library(methods)
library(RSelenium)
library(testthat)
library(XML)

ISR_login <- Sys.getenv("ISR_login")
ISR_pwd <- Sys.getenv("ISR_pwd")

pJS <- phantom()
Sys.sleep(5)

remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open(silent = TRUE)
remDr$maxWindowSize()
remDr$setImplicitWaitTimeout(milliseconds = 20000)

siteURL <- "https://test.immunespace.org"

context_of <- function(file, what, url, level = NULL) {
  level <- ifelse(is.null(level), "", paste0(" (", level, " level) "))
  msg <- paste0("\n", file, ": testing '", what, "' page", level, "\n", url, "\n")
  context(msg)
}