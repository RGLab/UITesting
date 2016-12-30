context("front page")

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to website", {
  remDr$navigate(siteURL)
  siteTitle <- remDr$getTitle()[[1]]
  expect_equal(siteTitle, "Welcome to ImmuneSpace")
})

test_that("'public data summary' module is present", {
  webElems <- remDr$findElements(using = "id", value = "Summary")
  expect_equal(length(webElems), 1)
  
  webElems <- remDr$findElements(using = "css selector", value = "tr")
  expect_equal(length(webElems), 13)
  
  parsedTab <- readHTMLTable(htmlParse(remDr$getPageSource()[[1]]), stringsAsFactors = F)[[1]]
  namesCol <- c("Studies", "Participants", "\u00A0", "CyTOF", "ELISA", "ELISPOT", 
                "Flow Cytometry", "Gene Expression", "HAI", "HLA Typing", "MBAA", 
                "Neutralizing Antibody", "PCR")
  expect_equal(parsedTab[, 1], namesCol)
  expect_equal(sum(parsedTab[, 2] > 0), 13)
})

test_that("'recent announcements' module is present", {
  webElems <- remDr$findElements(using = "id", value = "News")
  expect_equal(length(webElems), 1)
  expect_true(webElems[[1]]$getElementText()[[1]] != "")
})

test_that("can log in", {
  id <- remDr$findElement(using = "id", value = "email")
  id$sendKeysToElement(list(ISR_login))

  pw <- remDr$findElement(using = "id", value = "password")
  pw$sendKeysToElement(list(ISR_pwd))

  loginButton <- remDr$findElement(using = "id", value = "submitButton")
  loginButton$clickElement()

  Sys.sleep(1)
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "News and Updates: /home")
})
