context(paste0("test-front.R: testing 'Front' page (", siteURL, ")"))

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to the page", {
  remDr$navigate(siteURL)
  siteTitle <- remDr$getTitle()[[1]]
  expect_equal(siteTitle, "Welcome to ImmuneSpace")
})

test_that("'Public Data Summary' module is present", {
  webElems <- remDr$findElements(using = "id", value = "Summary")
  expect_equal(length(webElems), 1)
  
  webElems <- remDr$findElements(using = "css selector", value = "tr")
  expect_equal(length(webElems), 13)
  
  parsedTab <- readHTMLTable(htmlParse(remDr$getPageSource()[[1]]), stringsAsFactors = F)[[1]]
  namesCol <- c("Studies", "Participants", "CyTOF", "ELISA", "ELISPOT", 
                "Flow Cytometry", "Gene Expression", "HAI", "HLA Typing", "MBAA", 
                "Neutralizing Antibody", "PCR")
  expect_equal(parsedTab[-3, 1], namesCol)
  expect_equal(sum(parsedTab[-3, 2] > 0), 12)
})

test_that("'Recent Announcements' module is present", {
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
  
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "News and Updates: /home")
})
