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

siteURL <- "https://www.immunespace.org"
