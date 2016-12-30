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
})

test_that("'recent announcements' module is present", {
  webElems <- remDr$findElements(using = "id", value = "News")
  expect_equal(length(webElems), 1)
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
