pageURL <- paste0(siteURL, "/GeneExpressionExplorer/Studies/SDY269/begin.view")
context(paste0("test-modules-gee.R: testing 'Gene Expression Explorer' page (", pageURL, ")"))


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
  expect_equal(pageTitle, "Gene Expression Explorer: /Studies/SDY269")
})

test_that("'Gene Expression Explorer' module is present", {
  dataExplorer <- remDr$findElements(using = "id", value = "ext-comp-1084")
  expect_equal(length(dataExplorer), 1)
})

test_that("tabs are present", {
  inputView_tab <- remDr$findElements(using = "id", value = "ext-comp-1081__ext-comp-1061")
  expect_equal(length(inputView_tab), 1)
  expect_equal(inputView_tab[[1]]$getElementText()[[1]], "Input / View")
  
  data_tab <- remDr$findElements(using = "id", value = "ext-comp-1081__ext-comp-1072")
  expect_equal(length(data_tab), 1)
  expect_equal(data_tab[[1]]$getElementText()[[1]], "Data")
  
  about_tab <- remDr$findElements(using = "id", value = "ext-comp-1081__ext-comp-1082")
  expect_equal(length(about_tab), 1)
  expect_equal(about_tab[[1]]$getElementText()[[1]], "About")
  
  help_tab <- remDr$findElements(using = "id", value = "ext-comp-1081__ext-comp-1083")
  expect_equal(length(help_tab), 1)
  expect_equal(help_tab[[1]]$getElementText()[[1]], "Help")
})