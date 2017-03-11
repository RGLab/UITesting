pageURL <- paste0(siteURL, "/ImmuneResponsePredictor/Studies/SDY269/begin.view")
context(paste0("test-modules-irp.R: testing 'Immune Response Predictor' page (", pageURL, ")\n"))

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
    
    while(remDr$getTitle()[[1]] == "Sign In") Sys.sleep(1)
  }
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "Immune Response Predictor: /Studies/SDY269")
})

test_that("'Immune Response Predictor' module is present", {
  IRP <- remDr$findElements(using = "id", value = "ext-comp-1076")
  expect_equal(length(IRP), 1)
})

test_that("tabs are present", {
  input_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1051")
  expect_equal(length(input_tab), 1)
  expect_equal(input_tab[[1]]$getElementText()[[1]], "Input")
  
  data_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1062")
  expect_equal(length(data_tab), 1)
  expect_equal(data_tab[[1]]$getElementText()[[1]], "View")
  
  about_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1074")
  expect_equal(length(about_tab), 1)
  expect_equal(about_tab[[1]]$getElementText()[[1]], "About")
  
  help_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1075")
  expect_equal(length(help_tab), 1)
  expect_equal(help_tab[[1]]$getElementText()[[1]], "Help")
})