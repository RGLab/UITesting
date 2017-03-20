if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/reports/Studies/SDY269/runReport.view?reportId=module%3ASDY269%2Freports%2Fschemas%2Fhai_flow_elispot.Rmd")
context_of(file = "test-reports-sdy269.R", 
           what = "SDY269 Report", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Correlating HAI with flow cytometry and ELISPOT: /Studies/SDY269")

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