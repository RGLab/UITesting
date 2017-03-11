pageURL <- paste0(siteURL, "/reports/Studies/SDY180/runReport.view?reportId=module%3ASDY180%2Freports%2Fschemas%2Fstudy%2Fdemographics%2Fplasmablast_abundance.Rmd")
context(paste0("test-reports-sdy180.R: testing 'SDY180 Report' page (", pageURL, ")\n"))

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
  expect_equal(pageTitle, "Measuring plasmablast abundance by multiparameter flow cytometry: /Studies/SDY180")
})

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- remDr$findElements(using = "id", 
                                      value = "abundance-of-plasmablasts-measured-by-multiparameter-flow-cytometry-in-sdy180")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]], 
               "Abundance of plasmablasts measured by multiparameter flow cytometry in SDY180")
})

test_that("report is producing plot", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  report_images <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "img")
  expect_equal(length(report_images), 1)
  
  if (length(report_images) == 1) {
    image_url <- report_images[[1]]$getElementAttribute("src")[[1]]
    
    remDr$navigate(image_url)
    expect_true(grepl(strsplit(image_url, split = "\\&")[[1]][2], remDr$getPageSource()[[1]]))
  }
})