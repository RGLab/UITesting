pageURL <- paste0(siteURL, "/reports/Studies/SDY269/runReport.view?reportId=module%3ASDY269%2Freports%2Fschemas%2Fhai_flow_elispot.Rmd")
context(paste0("test-reports-sdy269.R: testing 'SDY269 Report' page (", pageURL, ")\n"))

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
  expect_equal(pageTitle, "Correlating HAI with flow cytometry and ELISPOT: /Studies/SDY269")
})

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- remDr$findElements(using = "id", 
                                      value = "correlating-hai-with-flow-cytometry-and-elispot-results-in-sdy269")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]], 
               "Correlating HAI with flow cytometry and ELISPOT results in SDY269")
})

test_that("report is producing plots", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  report_images <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "img")
  expect_equal(length(report_images), 2)
  
  if (length(report_images) == 2) {
    image1_url <- report_images[[1]]$getElementAttribute("src")[[1]]
    image2_url <- report_images[[2]]$getElementAttribute("src")[[1]]
    
    remDr$navigate(image1_url)
    expect_true(grepl(strsplit(image1_url, split = "\\&")[[1]][2], remDr$getPageSource()[[1]]))

    remDr$navigate(image2_url)
    expect_true(grepl(strsplit(image2_url, split = "\\&")[[1]][2], remDr$getPageSource()[[1]]))
  }
})